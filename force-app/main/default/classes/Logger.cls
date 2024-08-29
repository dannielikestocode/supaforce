public without sharing class Logger {
    // private static final String LOGGER_CONFIGURATION_NAME = 'Logger Configuration';
    // private static final Logger_Configuration__mdt CONFIG;

    public static void debug(String message) {
        log(Severity.DEBUG, message, null);
    }

    public static void debug(String message, Object obj) {
        log(Severity.DEBUG, message, obj);
    }

    public static void info(String message) {
        log(Severity.INFO, message, null);
    }

    public static void info(String message, Object obj) {
        log(Severity.INFO, message, obj);
    }

    public static void warn(String message) {
        log(Severity.WARN, message, null);
    }

    public static void warn(String message, Object obj) {
        log(Severity.WARN, message, obj);
    }

    public static void error(String message) {
        log(Severity.ERROR, message, null);
    }

    public static void error(String message, Object obj) {
        log(Severity.ERROR, message, obj);
    }

    public static void fatal(String message) {
        log(Severity.FATAL, message, null);
    }

    public static void fatal(String message, Object obj) {
        log(Severity.FATAL, message, obj);
    }

    @TestVisible
    private static void log(Severity severityEnum, String message, Object obj) {
        // if (CONFIG == null) {
        //     CONFIG = Logger_Configuration__mdt.getInstance(LOGGER_CONFIGURATION_NAME);
        // }
    }

    private enum Severity { DEBUG, INFO, WARN, ERROR, FATAL }
}