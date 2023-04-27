import 'package:ab_smartly/default_http_client.dart';
import 'package:ab_smartly/default_http_client_config.dart';
import 'package:flutter_test/flutter_test.dart';

// all working

void main() {
  group('DefaultHTTPClient', () {
    //   late DefaultHTTPClientConfig config;
    //   late DefaultHTTPClient httpClient;
    //
    //   setUp(() {
    //     config = DefaultHTTPClientConfig();
    //     httpClient = DefaultHTTPClient.create(config);
    //   });
    //
    //   tearDown(() {
    //     httpClient.close();
    //   });
    //
    //   test('get should make a GET request and return response', () async {
    //     final HTTPClient mockClient = MockHTTPClient();
    //     final Response response = MockResponse();
    //     const url = 'https://example.com';
    //
    //     when(mockClient.get("", null, anyNamed('headers')))
    //         .thenAnswer((_) async => response);
    //
    //
    //     final result = await mockClient.get(url, null, null);
    //
    //     expect(result, equals(response));
    //     verify(mockClient.get(url, null,  null));
    //   });
    //
    //   test('post should make a POST request and return response', () async {
    //     final HTTPClient mockClient = MockHTTPClient();
    //     final response = MockResponse();
    //     final url = 'https://example.com';
    //
    //     when(mockClient.post("", null,
    //         anyNamed('headers'), anyNamed('body')))
    //         .thenAnswer((_) async => response);
    //
    //
    //     final result = await mockClient.post(url, null, null, null);
    //
    //     expect(result, equals(response));
    //     verify(mockClient.post(url, null, null, null));
    //   });
    //
    //   test('put should make a PUT request and return response', () async {
    //     final HTTPClient mockClient = MockHTTPClient();
    //     final response = MockResponse();
    //     final url = 'https://example.com';
    //
    //     when(mockClient.put("",
    //         null, anyNamed('headers'), anyNamed('body')))
    //         .thenAnswer((_) async => response);
    //
    //     final result = await mockClient.put(url, null, null, null);
    //
    //     expect(result, equals(response));
    //     verify(mockClient.put("url",null , null, null));
    //   });
    // });

    late DefaultHTTPClient client;

    setUp(() {
      client = DefaultHTTPClient.create(DefaultHTTPClientConfig());
    });

    test('GET request returns successful response', () async {
      final response = await client.get(
          'https://jsonplaceholder.typicode.com/posts/1', null, null);
      expect(response.getStatusCode(), equals(200));
      expect(
          response.getContentType(), equals('application/json; charset=utf-8'));
      expect(response.getContent(), isNotNull);
    });

    test('POST request returns successful response', () async {
      final body = {'title': 'foo', 'body': 'bar', 'userId': 1};
      final response = await client.post(
          'https://jsonplaceholder.typicode.com/posts',
          null,
          null,
          body.toString().codeUnits);
      expect(response.getStatusCode(), equals(201));
      expect(
          response.getContentType(), equals('application/json; charset=utf-8'));
      expect(response.getContent(), isNotNull);
    });

    test('PUT request returns successful response', () async {
      final body = {'title': 'foo', 'body': 'bar', 'userId': 1};
      final response = await client.put(
          'https://jsonplaceholder.typicode.com/posts/1',
          null,
          null,
          body.toString().codeUnits);
      expect(response.getStatusCode(), equals(200));
      expect(
          response.getContentType(), equals('application/json; charset=utf-8'));
      expect(response.getContent(), isNotNull);
    });


    test('Closes HTTP client without errors', () {
      expect(() => client.close(), returnsNormally);
    });

    test('Handles null values correctly', () async {
      final response = await client.get(
          'https://jsonplaceholder.typicode.com/posts', null, null);
      expect(response.getStatusCode(), equals(200));
      expect(
          response.getContentType(), equals('application/json; charset=utf-8'));
      expect(response.getContent(), isNotNull);
    });



  });
}
