public interface ISObjectBeforeUpdate {
    void handleBeforeUpdate(SObject[] oldRecords, Map<Id, SObject> oldRecordsMap,
                            SObject[] newRecords, Map<Id, SObject> newRecordsMap);
}