import 'dart:convert';
import 'dart:typed_data';

import 'package:ab_smartly/client.dart';
import 'package:ab_smartly/client_config.dart';
import 'package:ab_smartly/context_data_deserializer.mocks.dart';
import 'package:ab_smartly/context_event_serializer.dart';
import 'package:ab_smartly/context_event_serializer.mocks.dart';
import 'package:ab_smartly/default_context_data_serializer.dart';
import 'package:ab_smartly/default_context_data_serializer.mocks.dart';
import 'package:ab_smartly/default_context_event_serializer.dart';
import 'package:ab_smartly/default_context_event_serializer.mocks.dart';
import 'package:ab_smartly/default_http_client.dart';
import 'package:ab_smartly/default_http_client.mocks.dart';
import 'package:ab_smartly/http_client.dart';
import 'package:ab_smartly/http_client.mocks.dart';
import 'package:ab_smartly/json/context_data.dart';
import 'package:ab_smartly/json/publish_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


// some are not working

void main() {
  group("Client", () {
    // Future<Response> getByteResponse(Uint8List bytes) {
    //   return Future.value(DefaultResponse(
    //       statusCode: 200,
    //       statusMessage: "OK",
    //       contentType: "application/json; charset=utf8",
    //       content: bytes));
    // }
    //
    // test("testCreateThrowsWithInvalidConfig", () {
    //   expect(() {
    //     final config = ClientConfig.create()
    //       ..setAPIKey('test-api-key')
    //       ..setApplication('website')
    //       ..setEnvironment('dev');
    //
    //     Client.create(config);
    //   },
    //       throwsA(isA<ArgumentError>().having((ArgumentError e) => (e),
    //           'message', ArgumentError("Missing Endpoint configuration"))));
    //   // throwsA(isA<ArgumentError>().having(
    //   //     (ArgumentError e) => (e), 'message', ArgumentError("Missing Endpoint configuration"))));
    //
    //   // expect(() {
    //   //   final config = ClientConfig.create()
    //   //     ..setEndpoint('https://localhost/v1')
    //   //     ..setApplication('website')
    //   //     ..setEnvironment('dev');
    //   //
    //   //   Client.create(config);
    //   // },
    //   //     throwsA(isA<Exception>().having(
    //   //         (e) => e, 'message', 'Missing APIKey configuration')));
    //   //
    //   // expect(() {
    //   //   final config = ClientConfig.create()
    //   //     ..setEndpoint('https://localhost/v1')
    //   //     ..setAPIKey('test-api-key')
    //   //     ..setEnvironment('dev');
    //   //
    //   //   Client.create(config);
    //   // },
    //   //     throwsA(isA<Exception>().having((e) => e, 'message',
    //   //         'Missing Application configuration')));
    //   //
    //   // expect(() {
    //   //   final config = ClientConfig.create()
    //   //     ..setEndpoint('https://localhost/v1')
    //   //     ..setAPIKey('test-api-key')
    //   //     ..setApplication('website');
    //   //
    //   //   Client.create(config);
    //   // },
    //   //     throwsA(isA<Exception>().having((e) => e, 'message',
    //   //         'Missing Environment configuration')));
    // });
    //
    // test("description", () {
    //   final ClientConfig config = ClientConfig.create()
    //       .setEndpoint("https://localhost/v1")
    //       .setAPIKey("test-api-key")
    //       .setApplication("website")
    //       .setEnvironment("dev");
    //
    //   final List<int> dataBytes = utf8.encode("{}");
    //   final ContextData expected = ContextData();
    //
    //   final PublishEvent event = PublishEvent(
    //     hashed: true,
    //     units: [],
    //     publishedAt: 1,
    //     exposures: [],
    //     goals: [],
    //     attributes: [],
    //   );
    //   final List<int> publishBytes = [0];
    //
    //   final DefaultContextDataDeserializer deserCtor =
    //       MockDefaultContextDataDeserializer();
    //   when(deserCtor.deserialize(dataBytes, 0, dataBytes.length))
    //       .thenReturn(expected);
    //
    //   final DefaultContextEventSerializer serCtor =
    //       MockDefaultContextEventSerializer();
    //   when(serCtor.serialize(event)).thenReturn(publishBytes);
    //
    //   final DefaultHTTPClient httpClient = MockDefaultHTTPClient();
    //
    //   final Map<String, String> expectedQuery = {
    //     "application": "website",
    //     "environment": "dev",
    //   };
    //
    //   final Map<String, String> expectedHeaders = {
    //     "X-API-Key": "test-api-key",
    //     "X-Application": "website",
    //     "X-Environment": "dev",
    //     "X-Application-Version": "0",
    //     "X-Agent": "absmartly-java-sdk"
    //   };
    //
    //   when(httpClient.get("https://localhost/v1/context", expectedQuery, null))
    //       .thenReturn(getByteResponse(Uint8List.fromList(dataBytes)));
    //   when(httpClient.put("https://localhost/v1/context", null, expectedHeaders,
    //           publishBytes))
    //       .thenReturn(getByteResponse(Uint8List.fromList(publishBytes)));
    //
    //   final Client client = Client.create(config);
    //
    //   client.getContextData();
    //
    //   client.publish(event);
    //
    //   verify(httpClient.get(
    //           'https://localhost/v1/context', expectedQuery, null))
    //       .called(1);
    //   verify(httpClient.put('https://localhost/v1/context', null,
    //           expectedHeaders, publishBytes))
    //       .called(1);
    //   verify(httpClient.close()).called(1);
    //
    //   verify(deserCtor.deserialize(dataBytes, 0, dataBytes.length)).called(1);
    //   verify(serCtor.serialize(event)).called(1);
    // });
    //
    // test('getContextData', () async {
    //   final httpClient = MockHTTPClient();
    //   final deser = MockContextDataDeserializer();
    //   final client = Client(
    //     ClientConfig()
    //         .setEndpoint('https://localhost/v1')
    //         .setAPIKey('test-api-key')
    //         .setApplication("website")
    //         .setEnvironment("dev")
    //         .setContextDataDeserializer(deser),
    //     httpClient,
    //   );
    //
    //   final bytes = utf8.encode('{}');
    //
    //   final expectedQuery = {
    //     'application': 'website',
    //     'environment': 'dev',
    //   };
    //
    //   when(httpClient.get(
    //     'https://localhost/v1/context',
    //     anyNamed('headers'),
    //     expectedQuery,
    //   )).thenAnswer((_) async => Future.value(DefaultResponse(
    //       statusCode: 200,
    //       statusMessage: "",
    //       contentType: "",
    //       content: bytes)));
    //
    //   final expected = ContextData();
    //   when(deser.deserialize(bytes, null, null)).thenReturn(expected);
    //
    //   final dataFuture = client.getContextData();
    //   final actual = await dataFuture;
    //
    //   expect(actual, equals(expected));
    //   expect(identical(actual, expected), isTrue);
    // });
    //
    // test('getContextDataExceptionallyHTTP', () async {
    //   final HTTPClient httpClient = MockHTTPClient();
    //   final deser = MockContextDataDeserializer();
    //
    //   final client = Client(
    //     ClientConfig()
    //         .setEndpoint('https://localhost/v1')
    //         .setAPIKey('test-api-key')
    //         .setApplication("website")
    //         .setEnvironment("dev")
    //         .setContextDataDeserializer(deser),
    //     httpClient,
    //   );
    //
    //   final expectedQuery = {
    //     'application': 'website',
    //     'environment': 'dev',
    //   };
    //
    //   var url = Uri.parse('https://localhost/v1/context')
    //       .replace(queryParameters: expectedQuery);
    //   when(httpClient.get('https://localhost/v1/context', expectedQuery,
    //           anyNamed('headers')))
    //       .thenAnswer((_) => Future.value(DefaultResponse(
    //           statusCode: 500,
    //           statusMessage: "",
    //           contentType: "",
    //           content: [])));
    //
    //   final dataFuture = client.getContextData();
    //   final actual = await expectLater(dataFuture, throwsA(isA<Exception>()))
    //       .then((_) => Future.value(Exception('Internal Server Error')));
    //
    //   verify(
    //     httpClient.get(
    //       'https://localhost/v1/context',
    //       expectedQuery,
    //       anyNamed('headers'),
    //     ),
    //   );
    //   verifyNever(deser.deserialize(any, any, any));
    // });
    //
    // test('getContextDataExceptionallyConnection', () async {
    //   final HTTPClient httpClient = MockHTTPClient();
    //   final deser = MockContextDataDeserializer();
    //
    //   final client = Client(
    //     ClientConfig()
    //         .setEndpoint('https://localhost/v1')
    //         .setAPIKey('test-api-key')
    //         .setApplication("website")
    //         .setEnvironment("dev")
    //         .setContextDataDeserializer(deser),
    //     httpClient,
    //   );
    //
    //   final Map<String, String> expectedQuery = {
    //     'application': 'website',
    //     'environment': 'dev'
    //   };
    //
    //   final Exception failure = Exception('FAILED');
    //   final Future<Response> responseFuture = Future.error(failure);
    //
    //   when(httpClient.get('https://localhost/v1/context', expectedQuery, null))
    //       .thenAnswer((_) => responseFuture);
    //
    //   final Future<ContextData?> dataFuture = client.getContextData();
    //   final actual = expectAsync0(() => expect(
    //       () => dataFuture.then((_) {}),
    //       throwsA(isA<Exception>()
    //           .having((e) => e.toString(), 'toString', 'Exception: FAILED'))));
    //
    //   verify(httpClient.get(
    //           'https://localhost/v1/context', expectedQuery, null))
    //       .called(1);
    //   verify(deser.deserialize(any, any, any)).called(0);
    // });
    //
    // test('publish', () async {
    //   final HTTPClient httpClient = MockHTTPClient();
    //   final ContextEventSerializer ser = MockContextEventSerializer();
    //   final client = Client(
    //     ClientConfig()
    //         .setEndpoint('https://localhost/v1')
    //         .setAPIKey('test-api-key')
    //         .setApplication("website")
    //         .setEnvironment("dev")
    //         .setContextEventSerializer(ser),
    //     httpClient,
    //   );
    //
    //   final Map<String, String> expectedHeaders = {
    //     'X-API-Key': 'test-api-key',
    //     'X-Application': 'website',
    //     'X-Environment': 'dev',
    //     'X-Application-Version': '0',
    //     'X-Agent': 'absmartly-java-sdk'
    //   };
    //   final PublishEvent event = PublishEvent(
    //     hashed: true,
    //     units: [],
    //     publishedAt: 1,
    //     exposures: [],
    //     goals: [],
    //     attributes: [],
    //   );
    //   final bytes = [0];
    //
    //   when(ser.serialize(event)).thenReturn(bytes);
    //   when(httpClient.put(
    //     'https://localhost/v1/context',
    //     null,
    //     expectedHeaders,
    //     bytes,
    //   )).thenAnswer(
    //       (_) => Future.value(getByteResponse(Uint8List.fromList([0]))));
    //
    //   final publishFuture = client.publish(event);
    //   await publishFuture;
    //
    //   verify(ser.serialize(event)).called(1);
    //   verify(httpClient.put(
    //     'https://localhost/v1/context',
    //     null,
    //     expectedHeaders,
    //     bytes,
    //   )).called(1);
    // });
    //
    // test('publishExceptionallyHTTP', () async {
    //   final HTTPClient httpClient = MockHTTPClient();
    //   final ContextEventSerializer ser = MockContextEventSerializer();
    //   final client = Client(
    //     ClientConfig()
    //         .setEndpoint('https://localhost/v1')
    //         .setAPIKey('test-api-key')
    //         .setApplication("website")
    //         .setEnvironment("dev")
    //         .setContextEventSerializer(ser),
    //     httpClient,
    //   );
    //
    //   final Map<String, String> expectedHeaders = {
    //     'X-API-Key': 'test-api-key',
    //     'X-Application': 'website',
    //     'X-Environment': 'dev',
    //     'X-Application-Version': '0',
    //     'X-Agent': 'absmartly-java-sdk'
    //   };
    //
    //   final PublishEvent event = PublishEvent(
    //     hashed: true,
    //     units: [],
    //     publishedAt: 1,
    //     exposures: [],
    //     goals: [],
    //     attributes: [],
    //   );
    //   final bytes = [0];
    //
    //   when(ser.serialize(event)).thenReturn(bytes);
    //   when(httpClient.put(
    //     'https://localhost/v1/context',
    //     null,
    //     expectedHeaders,
    //     bytes,
    //   )).thenAnswer((_) => Future.value(DefaultResponse(
    //       statusCode: 500,
    //       statusMessage: 'Internal Server Error',
    //       contentType: null,
    //       content: [0])));
    //
    //   final publishFuture = client.publish(event);
    //   final actual = await expectLater(
    //       publishFuture,
    //       throwsA(isA<Exception>()
    //           .having((e) => e, 'message', 'Internal Server Error')));
    //
    //   verify(ser.serialize(event)).called(1);
    //   verify(httpClient.put(
    //     'https://localhost/v1/context',
    //     null,
    //     expectedHeaders,
    //     bytes,
    //   )).called(1);
    // });
    //
    // test('publishExceptionallyConnection', () async {
    //   final httpClient = MockHTTPClient();
    //   final serializer = MockContextEventSerializer();
    //   final client = Client(
    //     ClientConfig()
    //         .setEndpoint('https://localhost/v1')
    //         .setAPIKey('test-api-key')
    //         .setApplication("website")
    //         .setEnvironment("dev")
    //         .setContextEventSerializer(serializer),
    //     httpClient,
    //   );
    //   final expectedHeaders = <String, String>{
    //     'X-API-Key': 'test-api-key',
    //     'X-Application': 'website',
    //     'X-Environment': 'dev',
    //     'X-Application-Version': '0',
    //     'X-Agent': 'absmartly-java-sdk',
    //   };
    //   final PublishEvent event = PublishEvent(
    //     hashed: true,
    //     units: [],
    //     publishedAt: 1,
    //     exposures: [],
    //     goals: [],
    //     attributes: [],
    //   );
    //   final bytes = [0];
    //   final failure = Exception('FAILED');
    //   final responseFuture = Future.error(failure);
    //   when(serializer.serialize(event)).thenReturn(bytes);
    //   final publishFuture = client.publish(event);
    //   expect(publishFuture, throwsA(isA<Exception>()));
    //   verify(serializer.serialize(event)).called(1);
    //   verify(httpClient.put(
    //           'https://localhost/v1/context', null, expectedHeaders, bytes))
    //       .called(1);
    // });

    test(
        'create method should return a new instance of Client with a default HTTPClient if httpClient is null',
        () {
      final config = ClientConfig()
          .setEndpoint("https://example.com")
          .setAPIKey("test-api-key")
          .setApplication("website").setEnvironment("dev");
      final client = Client.create(config);

      expect(client.runtimeType, equals(Client));
      expect(client.url_, equals('https://example.com/context'));
      expect(client.query_,
          equals({'application': 'website', 'environment': 'dev'}));
      expect(client.headers_['X-API-Key'], equals('test-api-key'));
      expect(client.headers_['X-Application'], equals('website'));
      expect(client.headers_['X-Environment'], equals('dev'));
      expect(client.headers_['X-Application-Version'], equals('0'));
      expect(client.headers_['X-Agent'], equals('absmartly-dart-sdk'));
      expect(client.httpClient_.runtimeType, equals(DefaultHTTPClient));
    });
    final config = ClientConfig()
        .setEndpoint("https://example.com")
        .setAPIKey("test-api-key")
        .setApplication("website").setEnvironment("dev");


    // not working
    // test('Client constructor throws ArgumentError when endpoint_ is null or empty', () {
    //   final config = ClientConfig()
    //       .setAPIKey("test-api-key").setEndpoint("")
    //       .setApplication("website").setEnvironment("dev");
    //   // final client  = Client.create(config,httpClient: MockHTTPClient());
    //   expect(Client(config,MockHTTPClient()),throwsA(isA<ArgumentError>()));
    //   // expect(() => Client(ClientConfig(endpoint_: '', apiKey_: 'test', application_: 'test', environment_: 'test'), MockHTTPClient()), throwsArgumentError);
    // });

    test('Client constructor initializes properties correctly', () {
      final config = ClientConfig()
          .setEndpoint("https://example.com")
          .setAPIKey("test-api-key")
          .setApplication("website").setEnvironment("dev");;
      final httpClient = MockHTTPClient();
      final client = Client(config, httpClient);
      expect(client.url_, equals('https://example.com/context'));
      expect(client.query_, equals({'application': 'website', 'environment': 'dev'}));
      expect(client.headers_, equals({
        'X-API-Key': 'test-api-key',
        'X-Application': 'website',
        'X-Environment': 'dev',
        'X-Application-Version': '0',
        'X-Agent': 'absmartly-dart-sdk',
      }));
      expect(client.httpClient_, equals(httpClient));
      expect(client.deserializer_, isNotNull);
      expect(client.serializer_, isNotNull);
    });



  });
}
