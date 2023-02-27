import 'package:ab_smartly/http_client.dart';

import 'default_http_client_config.dart';

class DefaultHTTPClient implements HTTPClient{

  static DefaultHTTPClient create(final DefaultHTTPClientConfig config) {
    return DefaultHTTPClient(config);

  }



  @override
  void close() {
    // TODO: implement close
  }

  @override
  Future<Response> get(String url, Map<String, String> query, Map<String, String>? headers) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Response> post(String url, Map<String, String> query, Map<String, String> headers, List<int> body) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<Response> put(String url, Map<String, String>? query, Map<String, String> headers, List<int> body) {
    // TODO: implement put
    throw UnimplementedError();
  }



   // final CloseableHttpAsyncClient httpClient_;


}