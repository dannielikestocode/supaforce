public without sharing class CalloutBuilder {
    private static final String DEFAULT_EXCEPTION_MESSAGE = 'Callout failed';
    private HttpRequest request {get;set;}
    private String successHttpStatus {get;set;}
    private Integer successHttpStatusCode {get;set;}

    public CalloutBuilder() {
        this.request = new HttpRequest();
    }

    public String getBody() {
        return this.request.getBody();
    }
    
    public Blob getBodyAsBlob() {
        return this.request.getBodyAsBlob();
    }

    public Dom.Document getBodyDoccument() {
        return this.request.getBodyDocument();
    }

    public Boolean getCompressed() {
        return this.request.getCompressed();
    }

    public String getEndpoint() {
        return this.request.getEndpoint();
    }

    public String getHeader(String key) {
        return this.request.getHeader(key);
    }

    public String getMethod() {
        return this.request.getMethod();
    }

    public HttpMethod getHttpMethod() {
        String method = this.request.getMethod();
        HttpMethod methodEnum;
        switch on method {
            when 'POST' {
                methodEnum = HttpMethod.POST;
            }
            when 'GET' {
                methodEnum = HttpMethod.GET;
            }
            when 'PUT' {
                methodEnum = HttpMethod.PUT;
            }
            when 'PATCH' {
                methodEnum = HttpMethod.PATCH;
            }
            when 'DELETE' {
                methodEnum = HttpMethod.DEL;
            }
            when 'HEAD' {
                methodEnum = HttpMethod.HEAD;
            }
            when 'TRACE' {
                methodEnum = HttpMethod.TRACE;
            }
        }
        return methodEnum;
    }

    public CalloutBuilder setBody(String body) {
        this.request.setBody(body);
        return this;
    }

    public CalloutBuilder setBodyAsBlob(Blob body) {
        this.request.setBodyAsBlob(body);
        return this;
    }

    public CalloutBuilder setBodyDocument(Dom.Document body) {
        this.request.setBodyDocument(body);
        return this;
    }

    public CalloutBuilder setClientCertificate(String certificateName) {
        this.request.setClientCertificateName(certificateName);
        return this;
    }

    public CalloutBuilder setCompressed(Boolean compressBody) {
        this.request.setCompressed(compressBody);
        return this;
    }

    public CalloutBuilder setEndpoint(String endpoint) {
        this.request.setEndpoint(endpoint);
        return this;
    }

    public CalloutBuilder setHeader(String key, String value) {
        this.request.setHeader(key, value);
        return this;
    }

    public CalloutBuilder setHeaders(Map<String, String> headers) {
        for (String key: headers.keySet()) {
            this.request.setHeader(key, headers.get(key));
        }
        return this;
    }

    public CalloutBuilder setMethod(HttpMethod methodEnum) {
        String method = methodEnum.name();
        if (methodEnum == HttpMethod.DEL) {
            method = 'DELETE';
        }
        this.request.setMethod(method);
        return this;
    }

    public CalloutBuilder setTimeout(Integer timeout) {
        this.request.setTimeout(timeout);
        return this;
    }

    public CalloutBuilder setSuccessHttpStatus(String successHttpStatus) {
        this.successHttpStatus = successHttpStatus;
        return this;
    }

    public CalloutBuilder setSuccessHttpStatusCode(Integer successHttpStatusCode) {
        this.successHttpStatusCode = successHttpStatusCode;
        return this;
    }

    public HttpResponse send() {
        Http httpSender = new Http();
        HttpResponse response = httpSender.send(this.request);
        if ((this.successHttpStatus != null && this.successHttpStatus != response.getStatus()) || 
            (this.successHttpStatusCode != null && this.successHttpStatusCode != response.getStatusCode())) {
                throw new ExtendedCalloutException(DEFAULT_EXCEPTION_MESSAGE, response.getStatus(), response.getStatusCode());
        }
        return response;
    }

    public enum HttpMethod { POST, GET, PUT, PATCH, DEL, HEAD, TRACE }
}