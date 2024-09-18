public interface ISObjectAfterInsert {
    void handleAfterInsert(SObject[] newRecords, Map<Id, SObject> newRecordsMap);
}