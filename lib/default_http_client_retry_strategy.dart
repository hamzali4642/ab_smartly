import 'dart:io';
import 'dart:math';

 class DefaultHTTPClientRetryStrategy implements HttpRequestRetryStrategy {
   static const int MIN_RETRY_INTERVAL = 5;

   final int maxRetries;
   final int retryIntervalUs;

   DefaultHTTPClientRetryStrategy(this.maxRetries, int maxRetryIntervalMs) :
         retryIntervalUs = max(0, (2000 * (maxRetryIntervalMs - MIN_RETRY_INTERVAL)) ~/ (1 << maxRetries));

   @override
   bool retryRequest(HttpRequest request, IOException exception, int execCount, HttpContext context) {
     return execCount <= maxRetries;
   }

   @override
   bool retryRequest(HttpResponse response, int execCount, HttpContext context) {
     return (execCount <= maxRetries) && retryableCodes.contains(response.code);
   }

   @override
   Duration getRetryInterval(HttpResponse response, int execCount, HttpContext context) {
     return Duration(milliseconds: MIN_RETRY_INTERVAL + (((1 << (execCount - 1)) * retryIntervalUs) ~/ 1000));
   }

   static final Set<int> retryableCodes = {502, 503}.toSet();
 }