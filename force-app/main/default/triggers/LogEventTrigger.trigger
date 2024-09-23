trigger LogEventTrigger on Log_Event__e (after insert) {
    TriggerActionDispatcher.execute('LogEventTrigger');
}