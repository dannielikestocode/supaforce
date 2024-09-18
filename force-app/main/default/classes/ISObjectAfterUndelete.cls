public interface ISObjectAfterUndelete {
    void handleAfterUndelete(SObject[] oldRecords, Map<Id, SObject> oldRecordsMap,
                             SObject[] newRecords, Map<Id, SObject> newRecordsMap);
}