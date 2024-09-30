public without sharing class CalloutBuilder {
    private static final String DEFAULT_EXCEPTION_MESSAGE = 'Callout failed';

    private HttpRequest request {get;set;}
    private String successHttpStatus {get;set;}
    private Integer successHttpStatusCode {get;set;}
    private String endpoint {get;set;}
    private String urlEncodingScheme {get;set;}
    private Map<String, String> urlParams {get;set;}

    public CalloutBuilder() {
        this.request = new HttpRequest();
    }

    public String getBody() {
        return this.request.getBody();
    }
    
    public Blob getBodyAsBlob() {
        return this.request.getBodyAsBlob();
    }

    public Dom.Document getBodyDocument() {
        return this.request.getBodyDocument();
    }

    public Boolean getCompressed() {
        return this.request.getCompressed();
    }

    public String getEndpoint() {
        return this.endpoint;
    }

    public String getUrlEncodingScheme() {
        return this.urlEncodingScheme;
    }

    public String getHeader(String key) {
        return this.request.getHeader(key);
    }

    public String getMethod() {
        return this.request.getMethod();
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
        this.endpoint = endpoint;
        return this;
    }

    public CalloutBuilder setUrlEncodingScheme(String urlEncodingScheme) {
        this.urlEncodingScheme = urlEncodingScheme;
        return this;
    }

    public CalloutBuilder setUrlParam(String key, String value) {
        if (this.urlParams == null) {
            this.urlParams = new Map<String, String>();
        }
        this.urlParams.put(key, value);
        return this;
    }

    public CalloutBuilder setHeader(String key, String value) {
        this.request.setHeader(key, value);
        return this;
    }

    public CalloutBuilder setMethod(String method) {
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
        this.request.setEndpoint(buildEndpoint());
        Http httpSender = new Http();
        HttpResponse response = httpSender.send(this.request);
        if ((this.successHttpStatus != null && this.successHttpStatus != response.getStatus()) || 
            (this.successHttpStatusCode != null && this.successHttpStatusCode != response.getStatusCode())) {
                throw new HttpException(DEFAULT_EXCEPTION_MESSAGE, response.getStatus(), response.getStatusCode());
        }
        return response;
    }

    private String buildEndpoint() {
        if (this.urlParams == null || this.urlParams.isEmpty()) {
            return '';
        }

        List<String> params = new List<String>{this.endpoint, '?'};
        Integer parameterCount = this.urlParams.size();
        for (String key: this.urlParams.keySet()) {
            params.add(key);
            params.add('=');
            params.add(this.urlParams.get(key));

            if ((parameterCount - 1) > 0) {
                // A value of 0 indicates the end of the param list,
                // meaning we shouldn't add anymore param separators
                params.add('&');
            }
            parameterCount--;
        }
        return String.isNotBlank(this.urlEncodingScheme) ? EncodingUtil.urlEncode(String.join(params, ''), this.urlEncodingScheme) : String.join(params, '');
    }
}