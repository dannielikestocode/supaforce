public interface ILogger {    
    void error(String message);
    void error(String message, Object obj);
    void warn(String message);
    void warn(String message, Object obj);
    void info(String message);
    void info(String message, Object obj);
    void debug(String message);
    void debug(String message, Object obj);
}