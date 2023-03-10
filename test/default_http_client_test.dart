import 'package:ab_smartly/default_http_client_config.dart';
import 'package:ab_smartly/http_client.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ab_smartly/http_client.dart';
import 'package:ab_smartly/default_http_client.dart';


void main() {
  group('DefaultHTTPClient', () {
    late DefaultHTTPClientConfig config;
    late DefaultHTTPClient httpClient;

    setUp(() {
      config = DefaultHTTPClientConfig();
      httpClient = DefaultHTTPClient.create(config);
    });

    tearDown(() {
      httpClient.close();
    });

    test('get should make a GET request and return response', () async {
      final HTTPClient mockClient = MockHTTPClient();
      final Response response = MockResponse();
      const url = 'https://example.com';

      when(mockClient.get("", null, anyNamed('headers')))
          .thenAnswer((_) async => response);


      final result = await mockClient.get(url, null, null);

      expect(result, equals(response));
      verify(mockClient.get(url, null,  null));
    });

    test('post should make a POST request and return response', () async {
      final HTTPClient mockClient = MockHTTPClient();
      final response = MockResponse();
      final url = 'https://example.com';

      when(mockClient.post("", null,
          anyNamed('headers'), anyNamed('body')))
          .thenAnswer((_) async => response);


      final result = await mockClient.post(url, null, null, null);

      expect(result, equals(response));
      verify(mockClient.post(url, null, null, null));
    });

    test('put should make a PUT request and return response', () async {
      final HTTPClient mockClient = MockHTTPClient();
      final response = MockResponse();
      final url = 'https://example.com';

      when(mockClient.put("",
          null, anyNamed('headers'), anyNamed('body')))
          .thenAnswer((_) async => response);

      final result = await mockClient.put(url, null, null, null);

      expect(result, equals(response));
      verify(mockClient.put("url",null , null, null));
    });
  });
}
