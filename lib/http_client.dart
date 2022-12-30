import 'package:ab_smartly/java_system_classes/closeable.dart';

abstract class HTTPClient extends Closeable{
  Response get(
      String url, Map<String, String> query, Map<String, String>? headers);

  Response put(String url, Map<String, String>? query,
      Map<String, String> headers, List<int> body);

  Response post(String url, Map<String, String> query,
      Map<String, String> headers, List<int> body);
}

abstract class Response {
  int getStatusCode();

  String getStatusMessage();

  String getContentType();

  List<int> getContent();
}
