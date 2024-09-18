public interface ISObjectAfterDelete {
    void handleAfterDelete(SObject[] oldRecords, Map<Id, SObject> oldRecordsMap);
}