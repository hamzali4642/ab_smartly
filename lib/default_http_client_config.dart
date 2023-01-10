// import 'http_version_policy.dart';
//
// class DefaultHTTPClientConfig {
//    static DefaultHTTPClientConfig create() {
//     return DefaultHTTPClientConfig();
//   }
//
//   DefaultHTTPClientConfig();
//
//    Provider getSecurityProvider() {
//     return securityProvider_;
//   }
//
//    DefaultHTTPClientConfig setSecurityProvider(Provider securityProvider) {
//     securityProvider_ = securityProvider;
//     return this;
//   }
//
//    int getConnectTimeout() => connectTimeout_;
//
//    DefaultHTTPClientConfig setConnectTimeout(final int connectTimeoutMs) {
//     connectTimeout_ = connectTimeoutMs;
//     return this;
//   }
//
//    int getConnectionKeepAlive() => connectionKeepAlive_;
//
//    DefaultHTTPClientConfig setConnectionKeepAlive(final int connectionKeepAliveMs) {
//     connectionKeepAlive_ = connectionKeepAliveMs;
//     return this;
//   }
//
//    long getConnectionRequestTimeout() {
//     return connectionRequestTimeout_;
//   }
//
//    DefaultHTTPClientConfig setConnectionRequestTimeout(final int connectionRequestTimeoutMs) {
//     connectionRequestTimeout_ = connectionRequestTimeoutMs;
//     return this;
//   }
//
//    int getMaxRetries() {
//     return maxRetries_;
//   }
//
//    DefaultHTTPClientConfig setMaxRetries(final int maxRetries) {
//     maxRetries_ = maxRetries;
//     return this;
//   }
//
//    long getRetryInterval() {
//     return retryInterval_;
//   }
//
//    DefaultHTTPClientConfig setRetryInterval(final int retryIntervalMs) {
//     retryInterval_ = retryIntervalMs;
//     return this;
//   }
//
//    HTTPVersionPolicy getHTTPVersionPolicy() {
//     return httpVersionPolicy_;
//   }
//
//    DefaultHTTPClientConfig setHTTPVersionPolicy(final HTTPVersionPolicy httpVersionPolicy) {
//     httpVersionPolicy_ = httpVersionPolicy;
//     return this;
//   }
//
//    Provider securityProvider_ = null;
//    int connectTimeout_ = 3000;
//    int connectionKeepAlive_ = 30000;
//    int connectionRequestTimeout_ = 1000;
//    int retryInterval_ = 333;
//    int maxRetries_ = 5;
//    HTTPVersionPolicy httpVersionPolicy_ = HTTPVersionPolicy.NEGOTIATE;
// }