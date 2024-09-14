public with sharing class HttpException extends Exception {
    public String httpStatus {get; private set;}
    public Integer httpStatusCode {get; private set;}

    public HttpException(String message, String httpStatus, Integer httpStatusCode) {
        this(message);
        this.httpStatus = httpStatus;
        this.httpStatusCode = httpStatusCode;
    }
}