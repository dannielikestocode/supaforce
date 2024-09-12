public with sharing class ExtendedCalloutException extends Exception {
    public String httpStatus {get; private set;}
    public Integer httpStatusCode {get; private set;}

    public ExtendedCalloutException(String message, String httpStatus, Integer httpStatusCode) {
        this(message);
        this.httpStatus = httpStatus;
        this.httpStatusCode = httpStatusCode;
    }
}