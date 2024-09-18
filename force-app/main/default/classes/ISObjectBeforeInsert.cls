public interface ISObjectBeforeInsert {
    void handleBeforeInsert(SObject[] newRecords);
}