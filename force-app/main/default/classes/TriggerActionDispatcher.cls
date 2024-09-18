public with sharing class TriggerActionDispatcher {
    // TODO: Determine what static variables to be set and reused
    // across transactions/execution contexts

    public static void execute(String targetTriggerApiName) {
        if (!Trigger.isExecuting) return;

        Trigger_Action_Configuration__c[] actions = getTriggerConfigurations(targetTriggerApiName);
        Set<String> classNames = new Set<String>();
        for (Trigger_Action_Configuration__c action: actions) {
            classNames.add(action.Class_Name__c);
        }

        ApexTypeImplementor[] apexClasses = getApexClasses(classNames, getCurrentContextInterface());
    }

    private static Trigger_Action_Configuration__c[] getTriggerConfigurations(String targetTriggerApiName) {
        return [SELECT Class_Name__c 
                FROM Trigger_Action_Configuration__c
                WHERE Is_Active__c = true
                    AND Target_Trigger__c = :targetTriggerApiName
                    AND Class_Name__c != null
                ORDER BY Priority__c ASC NULLS FIRST];
    }

    private static ApexTypeImplementor[] getApexClasses(Set<String> classNames, String triggerContextInterface) {
        return [SELECT ClassName, ClassNamespacePrefix
                FROM ApexTypeImplementor 
                WHERE InterfaceName =: triggerContextInterface 
                    AND IsConcrete = true];
    }
    
    private static String getCurrentContextInterface() {
        System.TriggerOperation opsType = Trigger.operationType;
        String interfaceName;
        switch on opsType {
            when BEFORE_INSERT {

            }	
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {

            }
            when AFTER_UPDATE {

            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
        return interfaceName;
    }
 }