public interface ISObjectBeforeDelete {
    void handleBeforeDelete(SObject[] oldRecords, Map<Id, SObject> oldRecordsMap);
}