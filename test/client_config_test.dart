import 'package:ab_smartly/client_config.dart';
import 'package:ab_smartly/context_data_deserializer.dart';
import 'package:ab_smartly/context_data_deserializer.mocks.dart';
import 'package:ab_smartly/context_event_serializer.dart';
import 'package:ab_smartly/context_event_serializer.mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClientConfig', ()
  {
    test('setEndpoint', () {
      final config = ClientConfig.create().setEndpoint(
          'https://test.endpoint.com');
      expect(config.getEndpoint(), equals('https://test.endpoint.com'));
    });

    test('setAPIKey', () {
      final config = ClientConfig.create().setAPIKey('api-key-test');
      expect(config.getAPIKey(), equals('api-key-test'));
    });

    test('setEnvironment', () {
      final config = ClientConfig.create().setEnvironment('test');
      expect(config.getEnvironment(), equals('test'));
    });

    test('setApplication', () {
      final config = ClientConfig.create().setApplication('website');
      expect(config.getApplication(), equals('website'));
    });

    test('setContextDataDeserializer', () {
      final deserializer = MockContextDataDeserializer();
      final config = ClientConfig.create().setContextDataDeserializer(
          deserializer);
      expect(config.getContextDataDeserializer(), equals(deserializer));
    });

    test('setContextEventSerializer', () {
      final serializer = MockContextEventSerializer();
      final config = ClientConfig.create().setContextEventSerializer(
          serializer);
      expect(config.getContextEventSerializer(), equals(serializer));
    });


    test('setAll', () {
      final ContextDataDeserializer deserializer = MockContextDataDeserializer();
      final ContextEventSerializer serializer = MockContextEventSerializer();

      final config = ClientConfig.create()
          .setEndpoint('https://test.endpoint.com')
          .setAPIKey('api-key-test')
          .setEnvironment('test')
          .setApplication('website')
          .setContextDataDeserializer(deserializer)
          .setContextEventSerializer(serializer);
      expect(config.getEndpoint(), equals('https://test.endpoint.com'));
      expect(config.getAPIKey(), equals('api-key-test'));
      expect(config.getEnvironment(), equals('test'));
      expect(config.getApplication(), equals('website'));
      expect(config.getContextDataDeserializer(), equals(deserializer));
      expect(config.getContextEventSerializer(), equals(serializer));
    });
  });
}
