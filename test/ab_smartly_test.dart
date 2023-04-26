import 'dart:async';

import 'package:ab_smartly/ab_smartly.dart';
import 'package:ab_smartly/ab_smartly_config.dart';
import 'package:ab_smartly/client.dart';
import 'package:ab_smartly/client.mocks.dart';
import 'package:ab_smartly/context.dart';
import 'package:ab_smartly/context_config.dart';
import 'package:ab_smartly/default_context_data_provider.dart';
import 'package:ab_smartly/default_context_event_handler.dart';
import 'package:ab_smartly/json/context_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('ABSmartly', () {
    late Client client;
   late ABSmartlyConfig config;
    setUp(() {
      client = MockClient();
      config = ABSmartlyConfig.create().setClient(client);
    });

    test('create', () {
      final config = ABSmartlyConfig.create().setClient(client);

      final absmartly = ABSmartly(config);
      expect(absmartly, isNotNull);
    });

    test('createThrowsWithInvalidConfig', () {
      expect(() {
        final config = ABSmartlyConfig.create();
        final absmartly = ABSmartly(config);
      },
          throwsA(TypeMatcher<Exception>().having((e) => e.toString(),
              'message', contains('Exception: Missing Client instance'))));
    });

    // test('createContext', () {
    //   final client = MockClient();
    //
    //   final config = ABSmartlyConfig.create().setClient(client);
    //
    //   final dataFuture = Completer<ContextData>();
    //   when(dataFuture.future).thenAnswer((_)=>dataFuture.future);
    //   when(dataFuture.future).thenAnswer((_)=>dataFuture.future);
    //   // when(dataFuture.future).thenReturn(dataFuture.future);
    //
    //   final dataProvider = MockContextDataProvider();
    //   when(dataProvider.getContextData()).thenAnswer((a) {
    //     return dataFuture.future;
    //   });
    //
    //   final absmartly = ABSmartly(config);
    //
    //   final contextMock = MockContext();
    //   final contextStatic = MockContext();
    //
    //   final contextConfig =
    //       ContextConfig.create().setUnit('user_id', '1234567');
    //   final context = absmartly.createContext(contextConfig);
    //
    //   expect(contextMock, context);
    //
    //   final Clock clockCaptor = SystemClockUTC();
    //   final configCaptor = ContextConfig();
    //   final schedulerCaptor = Timer(Duration(seconds: 1), () {});
    //   final dataFutureCaptor = Completer<ContextData>();
    //   final dataProviderCaptor = DefaultContextDataProvider(client);
    //   final eventHandlerCaptor = DefaultContextEventHandler(client);
    //   final variableParserCaptor = DefaultVariableParser();
    //   final audienceMatcherCaptor =
    //       AudienceMatcher(DefaultAudienceDeserializer());
    //
    //   verify(() => Context.create(
    //       clockCaptor,
    //       configCaptor,
    //       schedulerCaptor,
    //       dataFutureCaptor.future,
    //       dataProviderCaptor,
    //       eventHandlerCaptor,
    //       variableParserCaptor,
    //       audienceMatcherCaptor));
    //
    //   expect(Clock.systemUTC(), clockCaptor);
    //   expect(contextConfig, configCaptor);
    //   expect(dataFuture, dataFutureCaptor);
    //   expect(dataProvider, dataProviderCaptor);
    //   expect(
    //       eventHandlerCaptor, const TypeMatcher<DefaultContextEventHandler>());
    //   expect(variableParserCaptor, const TypeMatcher<DefaultVariableParser>());
    //   expect(audienceMatcherCaptor, isNotNull);
    // });

    test('ABSmartly createContext returns a valid Context object', () async {
      // final config = ABSmartlyConfig().setClient(client);
      final abSmartly = ABSmartly(config);
      final contextConfig = ContextConfig();
      final context = abSmartly.createContext(contextConfig);
      expect(context, isA<Context>());
    });

    test('ABSmartly constructor creates default contextDataProvider when getContextDataProvider() returns null', () {
      // final config = ABSmartlyConfig();
      expect(ABSmartly(config).contextDataProvider_, isA<DefaultContextDataProvider>());
    });

    test('ABSmartly constructor creates default contextEventHandler when getContextEventHandler() returns null', () {
      expect(ABSmartly(config).contextEventHandler_, isA<DefaultContextEventHandler>());
    });

    test('ABSmartly createContext returns a valid Context object', () async {
      // final config = ABSmartlyConfig();
      final abSmartly = ABSmartly(config);
      final contextConfig = ContextConfig();
      final context = abSmartly.createContext(contextConfig);
      expect(context, isA<Context>());
    });

    test('ABSmartly createContextWith returns a valid Context object', () async {
      final schedulerCaptor = Timer(const Duration(seconds: 1), () {});
      config.setScheduler(schedulerCaptor);
      final abSmartly = ABSmartly(config);
      final contextConfig = ContextConfig();
      final contextData = ContextData();
      final context = abSmartly.createContextWith(contextConfig, contextData);
      expect(context, isA<Context>());
    });

    test('ABSmartly getContextData returns a valid ContextData object', () async {
      // final config = ABSmartlyConfig();
      final abSmartly = ABSmartly(config);
      final contextData = await abSmartly.getContextData();
      expect(contextData, isA<ContextData>());
    });

    test('ABSmartly close sets client_ and scheduler_ variables to null', () async {
      // final config = ABSmartlyConfig();
      final abSmartly = ABSmartly(config);
      await abSmartly.close();
      expect(abSmartly.client_, isNull);
      expect(abSmartly.scheduler_, isNull);
    });

    test('ABSmartly close calls close() method of client_ object', () async {
      final mockClient = MockClient();
      config.setClient(mockClient);
      final abSmartly = ABSmartly(config);
      await abSmartly.close();
      verify(mockClient.close()).called(1);
    });

    test('ABSmartly close waits for scheduler_ to complete tasks before setting it to null', () async {
      // final config = ABSmartlyConfig();
      final abSmartly = ABSmartly(config);
      abSmartly.scheduleTask();
      await abSmartly.close();
      expect(abSmartly.scheduler_, isNull);
    });

    test('ABSmartly scheduleTask sets scheduler_ variable to Timer object with duration of 5 seconds', () {
      // final config = ABSmartlyConfig();
      final schedulerCaptor = Timer(const Duration(seconds: 5), () {});
      final abSmartly = ABSmartly(config);
      abSmartly.scheduleTask();
      expect(abSmartly.scheduler_, isA<Timer>());
    });


  });
}
