
import 'package:ab_smartly/client.dart';
import 'package:ab_smartly/client_config.dart';
import 'package:ab_smartly/default_http_client.dart';
import 'package:ab_smartly/http_client.mocks.dart';
import 'package:flutter_test/flutter_test.dart';


// some are not working

void main() {
  group("Client", () {

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
