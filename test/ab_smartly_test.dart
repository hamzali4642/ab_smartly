import 'dart:async';

import 'package:ab_smartly/ab_smartly.dart';
import 'package:ab_smartly/ab_smartly_config.dart';
import 'package:ab_smartly/audience_matcher.dart';
import 'package:ab_smartly/client.dart';
import 'package:ab_smartly/client.mocks.dart';
import 'package:ab_smartly/context.dart';
import 'package:ab_smartly/context.mocks.dart';
import 'package:ab_smartly/context_config.dart';
import 'package:ab_smartly/context_data_provider.dart';
import 'package:ab_smartly/context_data_provider.mocks.dart';
import 'package:ab_smartly/context_event_handler.dart';
import 'package:ab_smartly/default_audience_deserializer.dart';
import 'package:ab_smartly/default_context_data_provider.dart';
import 'package:ab_smartly/default_context_event_handler.dart';
import 'package:ab_smartly/default_variable_parser.dart';
import 'package:ab_smartly/java/time/clock.dart';
import 'package:ab_smartly/java/time/internal/system_clock_utc.dart';
import 'package:ab_smartly/json/context_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('ABSmartly', () {
    late Client client;

    setUp(() {
      client = MockClient();
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
      }, throwsA(TypeMatcher<Exception>()
          .having((e) => e.toString(), 'message', contains('Missing Client instance configuration'))));
    });


    test('createContext', () {
      final client = MockClient();

      final config = ABSmartlyConfig.create().setClient(client);

      final dataFuture = Completer<ContextData>();
      when(dataFuture.future).thenReturn(dataFuture.future);
      when(dataFuture.future).thenReturn(dataFuture.future);

      final dataProvider = MockContextDataProvider();
      when(dataProvider.getContextData()).thenReturn(dataFuture.future);


      final absmartly = ABSmartly(config);


      final contextMock = MockContext();
      final contextStatic = MockContext();


      final contextConfig =
      ContextConfig.create().setUnit('user_id', '1234567');
      final context = absmartly.createContext(contextConfig);

      expect(contextMock, context);

      final Clock clockCaptor = SystemClockUTC();
      final configCaptor = ContextConfig();
      final schedulerCaptor = Timer(Duration(seconds: 1), () { });
      final dataFutureCaptor =
      Completer<ContextData>();
      final dataProviderCaptor = DefaultContextDataProvider(client);
      final eventHandlerCaptor = DefaultContextEventHandler(client);
      final variableParserCaptor = DefaultVariableParser();
      final audienceMatcherCaptor = AudienceMatcher(DefaultAudienceDeserializer());

      verify(() => Context.create(
          clockCaptor,
          configCaptor,
          schedulerCaptor,
          dataFutureCaptor.future,
          dataProviderCaptor,
          eventHandlerCaptor,
          variableParserCaptor,
          audienceMatcherCaptor));

      expect(Clock.systemUTC(), clockCaptor);
      expect(contextConfig, configCaptor);
      expect(dataFuture, dataFutureCaptor);
      expect(dataProvider, dataProviderCaptor);
      expect(eventHandlerCaptor,
          const TypeMatcher<DefaultContextEventHandler>());
      expect(variableParserCaptor,
          const TypeMatcher<DefaultVariableParser>());
      expect(audienceMatcherCaptor, isNotNull);
    });

  });
}
