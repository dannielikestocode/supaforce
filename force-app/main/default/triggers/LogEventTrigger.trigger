trigger LogEventTrigger on Log_Event__e (after insert) {
    List<Log_Event__e> logs = new List<Log_Event__e>();
    for (Log_Event__e event : Trigger.New) {
        Log_Event__e log = new Log_Event__e();
        logs.add(log);
    }
    if (logs.size() > 0) INSERT logs;
}