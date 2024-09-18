public interface ISObjectAfterUpdate {
    void handleAfterUpdate(SObject[] oldRecords, Map<Id, SObject> oldRecordsMap,
                           SObject[] newRecords, Map<Id, SObject> newRecordsMap);
}