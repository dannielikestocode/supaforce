public with sharing class LogEventTriggerHandler implements ISObjectAfterInsert {
    public void handleAfterInsert(SObject[] newRecords, Map<Id, SObject> newRecordsMap) {
        List<Log__c> logs = new List<Log__c>();
        for (SObject logEvent : newRecords) {
            Log__c log = new Log__c(
                Severity__c = (String)logEvent.get('Severity__c'),
                Executing_User_Id__c = (String)logEvent.get('Executing_User_Id__c'),
                Message__c = (String)logEvent.get('Message__c'),
                Transaction_Id__c = (String)logEvent.get('Transaction_Id__c'),
                Transaction_Type__c = (String)logEvent.get('Transaction_Type__c'),
                Transaction_Type_Short_Code__c = (String)logEvent.get('Transaction_Type_Short_Code__c'),
                Object_Data__c = (String)logEvent.get('Object_Data__c'),
                Exception_Name__c = (String)logEvent.get('Exception_Name__c'),
                Line_Number__c = (Integer)logEvent.get('Line_Number__c'),
                Exception_Message__c = (String)logEvent.get('Exception_Message__c'),
                Stack_Trace__c = (String)logEvent.get('Stack_Trace__c')
            );
            logs.add(log);
        }

        if (logs.size() > 0) {
            INSERT logs;
        }
    }
}