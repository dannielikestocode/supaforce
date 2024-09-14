public interface IBeforeInsertAction {
    void handleBeforeInsert(SObject[] newRecords);
}