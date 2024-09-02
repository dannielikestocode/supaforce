public without sharing class Logger implements ILogger {
    private final String LOGGER_CONFIGURATION_NAME = 'Logger Configuration';
    private final Integer MAX_MESSAGE_LENGTH = 255;

    private final List<Log_Event__e> logsToPublish;
    private final Integer flushLimit;
    private final Severity highestSeverity;
    private final Boolean enableSystemDebug;

    public Logger() {
        this.logsToPublish = new List<Log_Event__e>();
        this.flushLimit = 1;
        this.highestSeverity = Severity.ERROR;
        this.enableSystemDebug = false;
    }
    
    public Logger(Logger_Configuration__mdt config) {
        if (config == null) {
            return;
        }
        this.logsToPublish = new List<Log_Event__e>();
        this.flushLimit = config.Flush_Limit__c != null ? Integer.valueOf(config.Flush_Limit__c) : 1;
        this.highestSeverity = this.getSeverityFromText(config.Highest_Severity__c);
        this.enableSystemDebug = config.Enable_System_Debug__c;
    }

    public void error(String message) {
        publishLog(Severity.ERROR, message, null);
    }

    public void error(String message, Object obj) {
        publishLog(Severity.ERROR, message, obj);
    }

    public void warn(String message) {
        publishLog(Severity.WARN, message, null);
    }

    public void warn(String message, Object obj) {
        publishLog(Severity.WARN, message, obj);
    }

    public void info(String message) {
        publishLog(Severity.INFO, message, null);
    }

    public void info(String message, Object obj) {
        publishLog(Severity.INFO, message, obj);
    }

    public void debug(String message) {
        publishLog(Severity.DEBUG, message, null);
    }

    public void debug(String message, Object obj) {
        publishLog(Severity.DEBUG, message, obj);
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
                configuredSeverity = highestSeverity;
            }
        }
        return configuredSeverity;
    }

    @TestVisible
    private void publishLog(Severity logSeverity, String message, Object obj) {
        if (skipPublishingLog(logSeverity, message)) {
            return;
        }
    }

    private Boolean skipPublishingLog(Severity logSeverity, String message) {
        if (logSeverity.ordinal() > highestSeverity.ordinal() || String.isBlank(message) || message.length() > MAX_MESSAGE_LENGTH) {
            return true;
        }
        else {
            return false;
        }
    }

    private void flush() {
        if (flushLimit < 1 || (logsToPublish != null && logsToPublish.size() > flushLimit)) {
            logsToPublish.clear();
        }
    }

    private enum Severity { DEBUG, INFO, WARN, ERROR }
}