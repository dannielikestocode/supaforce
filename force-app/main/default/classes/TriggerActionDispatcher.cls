public with sharing class TriggerActionDispatcher {
    private static final String BEFORE_INSERT_INTERFACE = 'ISObjectBeforeInsert';
    private static final String BEFORE_UPDATE_INTERFACE = 'ISObjectBeforeUpdate';
    private static final String BEFORE_DELETE_INTERFACE = 'ISObjectBeforeDelete';
    private static final String AFTER_INSERT_INTERFACE = 'ISObjectAfterInsert';
    private static final String AFTER_UPDATE_INTERFACE = 'ISObjectAfterUpdate';
    private static final String AFTER_DELETE_INTERFACE = 'ISObjectAfterDelete';
    private static final String AFTER_UNDELETE_INTERFACE = 'ISObjectAfterUndelete';
    private static final List<String> TRIGGER_CONTEXT_INTERFACES = new List<String>{
        BEFORE_INSERT_INTERFACE,
        BEFORE_UPDATE_INTERFACE,
        BEFORE_DELETE_INTERFACE,
        AFTER_INSERT_INTERFACE,
        AFTER_UPDATE_INTERFACE,
        AFTER_DELETE_INTERFACE,
        AFTER_UNDELETE_INTERFACE
    };

    private static String targetContextInterface;
    private static List<Trigger_Action_Configuration__c> targetTriggerActions = new List<Trigger_Action_Configuration__c>();
    private static Map<String, ApexTypeImplementor> apexClassMap = new Map<String, ApexTypeImplementor>();

    public static void execute(String targetTriggerApiName) {
        if (!Trigger.isExecuting) {
            // Exit early if this isn't being executed
            // within a trigger context
            return;
        }

        setTargetContextInterface();
        setTargetTriggerActions();
        setApexClasses();
        executeContextActions(targetTriggerApiName);
    }

    private static void setTargetContextInterface() {
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                targetContextInterface = BEFORE_INSERT_INTERFACE;
            }	
            when BEFORE_UPDATE {
                targetContextInterface = BEFORE_UPDATE_INTERFACE;
            }
            when BEFORE_DELETE {
                targetContextInterface = BEFORE_DELETE_INTERFACE;
            }
            when AFTER_INSERT {
                targetContextInterface = AFTER_INSERT_INTERFACE;
            }
            when AFTER_UPDATE {
                targetContextInterface = AFTER_UPDATE_INTERFACE;
            }
            when AFTER_DELETE {
                targetContextInterface = AFTER_DELETE_INTERFACE;
            }
            when AFTER_UNDELETE {
                targetContextInterface = AFTER_UNDELETE_INTERFACE;
            }
        }
    }

    private static void setTargetTriggerActions() {
        if (targetTriggerActions.size() > 0) {
            // The full list of trigger configurations
            // will be persisted throughout the life
            // of an Apex transaction
            return;
        }

        targetTriggerActions = [SELECT Class_Name__c, Target_Trigger__c
                                FROM Trigger_Action_Configuration__c
                                WHERE Is_Active__c = true
                                    AND Class_Name__c != null
                                ORDER BY Priority__c ASC NULLS LAST];
    }

    private static void setApexClasses() {
        if (apexClassMap.size() > 0) {
            // The full list of implemented apex classes
            // will be persisted throughout the life
            // of an Apex transaction
            return;
        }

        for (ApexTypeImplementor apexClass: [SELECT ClassName, ClassNamespacePrefix, InterfaceName
                                             FROM ApexTypeImplementor 
                                             WHERE InterfaceName IN :TRIGGER_CONTEXT_INTERFACES
                                                AND IsConcrete = true]) {
            apexClassMap.put(apexClass.ClassName, apexClass);
        }
    }

    private static void executeContextActions(String targetTriggerApiName) {
        for (Trigger_Action_Configuration__c action: targetTriggerActions) {
            if (action.Target_Trigger__c != targetTriggerApiName) {
                continue;
            }

            ApexTypeImplementor apexClass = apexClassMap.get(action.Class_Name__c);
            if (apexClass?.InterfaceName != targetContextInterface) {
                continue;
            }

            switch on apexClass.InterfaceName {
                when 'ISObjectBeforeInsert' {
                    ISObjectBeforeInsert interfaceAction = (ISObjectBeforeInsert)Type.forName(apexClass.ClassNamespacePrefix, apexClass.ClassName).newInstance();
                    interfaceAction.handleBeforeInsert(Trigger.new);
                }	
                when 'ISObjectBeforeUpdate' {
                    ISObjectBeforeUpdate interfaceAction = (ISObjectBeforeUpdate)Type.forName(apexClass.ClassNamespacePrefix, apexClass.ClassName).newInstance();
                    interfaceAction.handleBeforeUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
                }
                when 'ISObjectBeforeDelete' {
                    ISObjectBeforeDelete interfaceAction = (ISObjectBeforeDelete)Type.forName(apexClass.ClassNamespacePrefix, apexClass.ClassName).newInstance();
                    interfaceAction.handleBeforeDelete(Trigger.old, Trigger.oldMap);
                }
                when 'ISObjectAfterInsert' {
                    ISObjectAfterInsert interfaceAction = (ISObjectAfterInsert)Type.forName(apexClass.ClassNamespacePrefix, apexClass.ClassName).newInstance();
                    interfaceAction.handleAfterInsert(Trigger.new, Trigger.newMap);
                }
                when 'ISObjectAfterUpdate' {
                    ISObjectAfterUpdate interfaceAction = (ISObjectAfterUpdate)Type.forName(apexClass.ClassNamespacePrefix, apexClass.ClassName).newInstance();
                    interfaceAction.handleAfterUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
                }
                when 'ISObjectAfterDelete' {
                    ISObjectAfterDelete interfaceAction = (ISObjectAfterDelete)Type.forName(apexClass.ClassNamespacePrefix, apexClass.ClassName).newInstance();
                    interfaceAction.handleAfterDelete(Trigger.old, Trigger.oldMap);
                }
                when 'ISObjectAfterUndelete' {
                    ISObjectAfterUndelete interfaceAction = (ISObjectAfterUndelete)Type.forName(apexClass.ClassNamespacePrefix, apexClass.ClassName).newInstance();
                    interfaceAction.handleAfterUndelete(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
                }
            }
        }
    }
 }