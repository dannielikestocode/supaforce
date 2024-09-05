public without sharing class Logger implements ILogger {
    private static final Integer MAX_MESSAGE_LENGTH = 255;

    private final String TRANSACTION_ID;
    private final Quiddity TRANSACTION_TYPE;
    private final String TRANSACTION_TYPE_SHORT_CODE;
    
    private final List<Log_Event__e> queuedLogs;
    private final Integer flushLimit;
    private final Severity minimumSeverity;
    private final Boolean enableSystemDebug;
    private final Boolean pauseLogging;

    public Logger() {
        Request currentRequest = Request.getCurrent();
        this.TRANSACTION_ID = currentRequest.getRequestId();
        this.TRANSACTION_TYPE = currentRequest.getQuiddity();
        this.TRANSACTION_TYPE_SHORT_CODE = System.getQuiddityShortCode(this.TRANSACTION_TYPE);

        this.queuedLogs = new List<Log_Event__e>();
        this.flushLimit = 1;
        this.minimumSeverity = Severity.ERROR;
        this.enableSystemDebug = false;
        this.pauseLogging = false;
    }
    
    public Logger(Logger_Configuration__mdt config) {
        Request currentRequest = Request.getCurrent();
        this.TRANSACTION_ID = currentRequest.getRequestId();
        this.TRANSACTION_TYPE = currentRequest.getQuiddity();
        this.TRANSACTION_TYPE_SHORT_CODE = System.getQuiddityShortCode(this.TRANSACTION_TYPE);
        this.queuedLogs = new List<Log_Event__e>();

        if (config == null) {    
            this.flushLimit = 1;
            this.minimumSeverity = Severity.ERROR;
            this.enableSystemDebug = false;
            this.pauseLogging = false;
            return;
        }
        
        this.flushLimit = config.Flush_Limit__c != null ? Integer.valueOf(config.Flush_Limit__c) : 1;
        this.minimumSeverity = this.getSeverityFromText(config.Minimum_Severity__c);
        this.enableSystemDebug = config.Enable_System_Debug__c;
        this.pauseLogging = config.Pause_Logging__c;
    }

    public void error(String message) {
        addToLogQueue(Severity.ERROR, message, null);
    }

    public void error(String message, Object obj) {
        addToLogQueue(Severity.ERROR, message, obj);
    }

    public void warn(String message) {
        addToLogQueue(Severity.WARN, message, null);
    }

    public void warn(String message, Object obj) {
        addToLogQueue(Severity.WARN, message, obj);
    }

    public void info(String message) {
        addToLogQueue(Severity.INFO, message, null);
    }

    public void info(String message, Object obj) {
        addToLogQueue(Severity.INFO, message, obj);
    }

    public void debug(String message) {
        addToLogQueue(Severity.DEBUG, message, null);
    }

    public void debug(String message, Object obj) {
        addToLogQueue(Severity.DEBUG, message, obj);
    }

    @TestVisible
    private Severity getSeverityFromText(String severityText) {
        if (String.isBlank(severityText)) {
            return Severity.ERROR;
        }

        Severity configuredSeverity;
        switch on severityText {
            when 'ERROR' {
                configuredSeverity = Severity.ERROR;
            }	
            when 'WARN' {
                configuredSeverity = Severity.WARN;
            }
            when 'INFO' {
                configuredSeverity = Severity.INFO;
            }
            when 'DEBUG' {
                configuredSeverity = Severity.DEBUG;
            }
            when else {
                configuredSeverity = this.minimumSeverity;
            }
        }
        return configuredSeverity;
    }

    @TestVisible
    private void addToLogQueue(Severity logSeverity, String message, Object obj) {
        if (this.skipPublishingLog(logSeverity, message)) {
            return;
        }

        Log_Event__e log = new Log_Event__e(
            Severity__c = logSeverity.name(),
            Executing_User_Id__c = UserInfo.getUserId(),
            Message__c = message.length() > MAX_MESSAGE_LENGTH ? message.substring(0, MAX_MESSAGE_LENGTH - 1) : message
        );
        this.setExecutionContextValues(log);
        this.setObjectValues(log, obj);
        this.publishAndFlush(log);
    }

    @TestVisible
    private Boolean skipPublishingLog(Severity logSeverity, String message) {
        Boolean skipPublishing = false;
        if (logSeverity.ordinal() < this.minimumSeverity.ordinal() || this.pauseLogging || String.isBlank(message)) {
            skipPublishing = true;
        }
        return skipPublishing;
    }

    @TestVisible
    private void setExecutionContextValues(Log_Event__e log) {
        log.Transaction_Id__c = this.TRANSACTION_ID;
        log.Transaction_Type__c = this.TRANSACTION_TYPE.name();
        log.Transaction_Type_Short_Code__c = this.TRANSACTION_TYPE_SHORT_CODE;
    }

    @TestVisible
    private void setObjectValues(Log_Event__e log, Object obj) {
        if (obj == null) {
            return;
        }

        if (obj instanceof Exception) {
            Exception e = (Exception)obj;
            log.Exception_Name__c = e.getTypeName();
            log.Line_Number__c = e.getLineNumber();
            log.Exception_Message__c = e.getMessage();
            log.Stack_Trace__c = e.getStackTraceString();
        }
        else {
            try {
                log.Object_Data__c = JSON.serialize(obj);
            }
            catch(Exception e) {
                log.Object_Data__c = 'JSON serialization failed for object data. Exception message: ' + e.getMessage(); 
            }
        }
    }

    @TestVisible
    private void publishAndFlush(Log_Event__e log) {
        this.queuedLogs.add(log);
        if (this.flushLimit <= 1 || this.queuedLogs.size() >= this.flushLimit) {
            EventBus.publish(this.queuedLogs);
            this.queuedLogs.clear();
        }
    }

    private enum Severity { DEBUG, INFO, WARN, ERROR }
}