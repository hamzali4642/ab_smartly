import 'dart:async';

import 'package:ab_smartly/audience_matcher.dart';
import 'package:ab_smartly/context.dart';
import 'package:ab_smartly/context_config.dart';
import 'package:ab_smartly/context_data_provider.dart';
import 'package:ab_smartly/context_data_provider.mocks.dart';
import 'package:ab_smartly/context_event_handler.dart';
import 'package:ab_smartly/context_event_handler.mocks.dart';
import 'package:ab_smartly/default_audience_deserializer.dart';
import 'package:ab_smartly/default_context_data_serializer.dart';
import 'package:ab_smartly/default_variable_parser.dart';
import 'package:ab_smartly/java/time/clock.dart';
import 'package:ab_smartly/json/attribute.dart';
import 'package:ab_smartly/json/context_data.dart';
import 'package:ab_smartly/json/experiment.dart';
import 'package:ab_smartly/json/exposure.dart';
import 'package:ab_smartly/json/publish_event.dart';
import 'package:ab_smartly/json/unit.dart';
import 'package:ab_smartly/variable_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'test_utils.dart';

// not working

void main() {
  group("context", () {
    final Map<String, String> units = {
      "session_id": "e791e240fcd3df7d238cfc285f475e8152fcc0ec",
      "user_id": "123456789",
      "email": "bleh@absmartly.com",
    };

    final Map<String, dynamic> attributes = {
      "attr1": "value1",
      "attr2": "value2",
      "attr3": 5,
    };

    final Map<String, int> expectedVariants = {
      "exp_test_ab": 1,
      "exp_test_abc": 2,
      "exp_test_not_eligible": 0,
      "exp_test_fullon": 2,
      "exp_test_new": 1,
    };

    final Map<String, dynamic> expectedVariables = {
      "banner.border": 1,
      "banner.size": "large",
      "button.color": "red",
      "submit.color": "blue",
      "submit.shape": "rect",
      "show-modal": true,
    };

    final Map<String, List<String>> variableExperiments = {
      "banner.border": ["exp_test_ab"],
      "banner.size": ["exp_test_ab"],
      "button.color": ["exp_test_abc"],
      "card.width": ["exp_test_not_eligible"],
      "submit.color": ["exp_test_fullon"],
      "submit.shape": ["exp_test_fullon"],
      "show-modal": ["exp_test_new"],
    };

    final List<Unit> publishUnits = [
      Unit(type: "user_id", uid: "JfnnlDI7RTiF9RgfG2JNCw"),
      Unit(type: "session_id", uid: "pAE3a1i5Drs5mKRNq56adA"),
      Unit(type: "email", uid: "IuqYkNRfEx5yClel4j3NbA"),
    ];

    late ContextData data;
    late ContextData refreshData;
    late ContextData audienceData;
    late ContextData audienceStrictData;
    late Future<ContextData> dataFutureReady;
    late Future<ContextData> dataFutureFailed;
    late Completer<ContextData> dataFuture;
    late Future<ContextData> refreshDataFutureReady;
    late Completer<ContextData> refreshDataFuture;
    late Future<ContextData> audienceDataFutureReady;
    late Future<ContextData> audienceStrictDataFutureReady;
    late ContextDataProvider dataProvider;
    late ContextEventHandler eventHandler;
    late VariableParser variableParser;
    late AudienceMatcher audienceMatcher;
    late Timer scheduler;
    late DefaultContextDataDeserializer deser =
        DefaultContextDataDeserializer();
    late Clock clock =
        Clock.fixed(DateTime(2021, 5, 14).millisecondsSinceEpoch);

    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      List<int> bytes = await getResourceBytes("context.json");
      data = deser.deserialize(bytes, 0, bytes.length)!;

      List<int> refreshBytes = await getResourceBytes("refreshed.json");
      refreshData = deser.deserialize(refreshBytes, 0, refreshBytes.length)!;
      debugPrint("resfreshed");

      List<int> audienceBytes = await getResourceBytes("audience_context.json");
      audienceData = deser.deserialize(audienceBytes, 0, audienceBytes.length)!;
      debugPrint("audience_context.json");

      List<int> audienceStrictBytes =
          await getResourceBytes("audience_strict_context.json");
      debugPrint("audience_strict_context.json");

      audienceStrictData = deser.deserialize(
          audienceStrictBytes, 0, audienceStrictBytes.length)!;
      debugPrint("audienceStrictBytes");
      Completer d = Completer();

      dataFutureReady = Future<ContextData>.value(data);
      // dataFutureFailed = Future.error(Exception("FAILED"));
      dataFuture = Completer<ContextData>();
      refreshDataFutureReady = Future<ContextData>.value(refreshData);
      refreshDataFuture = Completer<ContextData>();
      audienceDataFutureReady = Future<ContextData>.value(audienceData);
      audienceStrictDataFutureReady =
          Future<ContextData>.value(audienceStrictData);
      dataProvider = MockContextDataProvider();
      eventHandler = MockContextEventHandler();
      variableParser = DefaultVariableParser();
      audienceMatcher = AudienceMatcher(DefaultAudienceDeserializer());
      scheduler = Timer(const Duration(seconds: 5), () {});
    });
    Context createContext(
        ContextConfig? config, Future<ContextData> dataFuture) {
      if (config == null) {
        final ContextConfig config = ContextConfig.create().setUnits(units);
        return Context.create(clock, config, scheduler, dataFuture,
            dataProvider, eventHandler, variableParser, audienceMatcher);
      }
      return Context.create(clock, config, scheduler, dataFuture, dataProvider,
          eventHandler, variableParser, audienceMatcher);
    }

    Context createReadyContext(ContextData? data) {
      final ContextConfig config = ContextConfig.create().setUnits(units);
      if (data == null) {
        return Context.create(clock, config, scheduler, dataFutureReady,
            dataProvider, eventHandler, variableParser, audienceMatcher);
      }
      return Context.create(clock, config, scheduler, Future.value(data),
          dataProvider, eventHandler, variableParser, audienceMatcher);
    }

    // test("constructorSetsOverrides", () {
    //   final Map<String, int> overrides = {
    //     'exp_test': 2,
    //     'exp_test_1': 1,
    //   };
    //
    //   final ContextConfig config =
    //       ContextConfig.create().setUnits(units).setOverrides(overrides);
    //
    //   final Context context = createContext(config, dataFutureReady);
    //
    //   overrides.forEach((experimentName, variant) =>
    //       expect(context.getOverride(experimentName), equals(variant)));
    // });
    //
    // test("constructorSetsCustomAssignments", () {
    //   final Map<String, int> cassignments = {"exp_test": 2, "exp_test_1": 1};
    //
    //   final ContextConfig config = ContextConfig.create()
    //       .setUnits(units)
    //       .setCustomAssignments(cassignments);
    //
    //   final Context context = createContext(config, dataFutureReady);
    //   cassignments.forEach((experimentName, variant) =>
    //       expect(variant, context.getCustomAssignment(experimentName)));
    // });
    //
    // test('becomesReadyWithCompletedFuture', () {
    //   final context = createReadyContext(null);
    //   expect(context.isReady, isTrue);
    //   expect(context.getData(), equals(data));
    // });
    //
    // test('becomesReadyAndFailedWithException', () async {
    //   final context = createContext(null, dataFuture.future);
    //   expect(context.isReady, isFalse);
    //   expect(context.isFailed, isFalse);
    //
    //   dataFuture.completeError(Exception('FAILED'));
    //
    //   await context.waitUntilReady();
    //
    //   expect(context.isReady, isTrue);
    //   expect(context.isFailed, isTrue);
    // });

    test('waitUntilReady', () async {
      final context = createContext(null, dataFuture.future);
      expect(context.isReady(), isFalse);

      final completer = dataFuture.complete(data);
      await context.waitUntilReady();

      expect(context.isReady(), isTrue);
      expect(context.getData(), same(data));
    });
    //
    // test('waitUntilReadyWithCompletedFuture', () {
    //   final context = createReadyContext(null);
    //   expect(context.isReady(), isTrue);
    //
    //   context.waitUntilReady();
    //   expect(context.getData(), same(data));
    // });
    //
    // test('waitUntilReadyAsync', () async {
    //   final context = createContext(null, dataFuture.future);
    //   expect(context.isReady(), isFalse);
    //
    //   final readyFuture = context.waitUntilReadyAsync();
    //   expect(context.isReady(), isFalse);
    //
    //   final completer = dataFuture.complete(data);
    //
    //   await readyFuture;
    //
    //   expect(context.isReady(), isTrue);
    //   expect(readyFuture, same(context));
    //   expect(context.getData(), same(data));
    // });
    //
    // test('waitUntilReadyAsyncWithCompletedFuture', () async {
    //   final context = createReadyContext(null);
    //   expect(context.isReady(), isTrue);
    //
    //   final readyFuture = context.waitUntilReadyAsync();
    //   await readyFuture;
    //
    //   expect(context.isReady(), isTrue);
    //   expect(readyFuture, same(context));
    //   expect(context.getData(), same(data));
    // });
    //
    // test("testGetExperiments", () {
    //   final context = createReadyContext(null);
    //   verify(context.isReady);
    //
    //   final experiments = data.experiments.map((e) => e.name).toList();
    //   expect(context.getExperiments(), experiments);
    // });
    //
    // test("testStartsRefreshTimerWhenReady", () async {
    //   final config = ContextConfig()
    //     ..units_ = units
    //     ..refreshInterval = 5000;
    //
    //   final context = createContext(config, dataFuture.future);
    //   expect(context.isReady, isFalse);
    //   expect(context.isFailed, isFalse);
    //
    //   dataFuture.complete(data);
    //   context.waitUntilReady();
    //
    //   verify(Timer.periodic(
    //           Duration(milliseconds: config.refreshInterval), (timer) {}))
    //       .called(1);
    //
    //   verify(() {
    //     dataProvider.getContextData();
    //   }).called(0);
    //   when(dataProvider.getContextData()).thenReturn(refreshDataFutureReady);
    //
    //   verify(() {
    //     dataProvider.getContextData();
    //   }).called(1);
    // });
    //
    // test("testDoesNotStartRefreshTimerWhenFailed", () {
    //   final config = ContextConfig()
    //     ..units_ = units
    //     ..refreshInterval = 5000;
    //
    //   final context = createContext(config, dataFuture.future);
    //   expect(context.isReady, isFalse);
    //   expect(context.isFailed, isFalse);
    //
    //   dataFuture.completeError(Exception('test'));
    //
    //   context.waitUntilReady();
    //   expect(context.isFailed, isTrue);
    //
    //   verify(() {
    //     Timer.periodic(const Duration(milliseconds: 0), (timer) {});
    //   });
    // });
    //
    test("setUnits", () {
      final Context context =
          createContext(ContextConfig.create(), dataFuture.future);
      context.waitUntilReady();
      context.setUnits(units);

      units.forEach((key, value) {
        expect(value, context.getUnit(key));
      });
    });
    //
    // test("setUnitsBeforeReady", () {
    //   final Context context =
    //       createContext(ContextConfig.create(), dataFuture.future);
    //   expect(false, context.isReady());
    //   context.setUnits(units);
    //   dataFuture.complete(data);
    //   context.waitUntilReady();
    //   context.getTreatment("exp_test_ab");
    //   context.publish();
    //   final PublishEvent expected = PublishEvent(
    //       hashed: true,
    //       units: publishUnits,
    //       publishedAt: clock.millis(),
    //       exposures: [
    //         Exposure(
    //             id: 1,
    //             name: "exp_test_ab",
    //             unit: "session_id",
    //             variant: 1,
    //             exposedAt: clock.millis(),
    //             assigned: true,
    //             eligible: true,
    //             overridden: false,
    //             fullOn: false,
    //             custom: false,
    //             audienceMismatch: false)
    //       ],
    //       goals: [],
    //       attributes: []);
    //   context.publish();
    //   verify(() {
    //     eventHandler.publish(context, expected);
    //   }).called(1);
    // });
    //
    test("setUnitEmpty", () {
      final Context context = createContext(null, dataFutureReady);

      expect(() {
        context.setUnit("db_user_id", "");
      },
          throwsException
);
    });
    //
    test("setUnitThrowsOnAlreadySet", () {
      final Context context = createContext(null, dataFutureReady);

      expect(() {
        context.setUnit('session_id', 'new_uid');
      },
          throwsException);
    });

    test("setAttributes", () {
      final Context context = createContext(null, dataFuture.future);
      context.setAttribute("attr1", "value1");
      context.setAttributes({"attr2": "value2", "attr3": 15});
      expect("value1", context.getAttribute("attr1"));
      expect({"attr1": "value1", "attr2": "value2", "attr3": 15},
          context.getAttributes());
    });


    test("setAttributesBeforeReady", () {
      final Context context = createContext(null, dataFuture.future);
      expect(false, context.isReady());

      context.setAttribute("attr1", "value1");
      context.setAttributes({"attr2": "value2"});

      expect("value1", context.getAttribute("attr1"));
      expect({"attr1": "value1", "attr2": "value2"}, context.getAttributes());

      dataFuture.complete(data);

      context.waitUntilReady();
    });

    // test("setOverride", () {
    //   final Context context = createReadyContext(null);
    //
    //   context.setOverride("exp_test", 2);
    //
    //   expect(2, context.getOverride("exp_test"));
    //
    //   context.setOverride("exp_test", 3);
    //   expect(3, context.getOverride("exp_test"));
    //
    //   context.setOverride("exp_test_2", 1);
    //   expect(1, context.getOverride("exp_test_2"));
    //
    //   final Map<String, int> overrides = {
    //     "exp_test_new": 3,
    //     "exp_test_new_2": 5
    //   };
    //
    //   context.setOverrides(overrides);
    //
    //   expect(3, context.getOverride("exp_test"));
    //   expect(1, context.getOverride("exp_test_2"));
    //   overrides.forEach((experimentName, variant) =>
    //       expect(variant, context.getOverride(experimentName)));
    //
    //   expect(null, context.getOverride("exp_test_not_found"));
    // });
    //
    // test("setOverrideClearsAssignmentCache", () {
    //   final Context context = createReadyContext(null);
    //
    //   final Map<String, int> overrides = {
    //     "exp_test_new": 3,
    //     "exp_test_new_2": 5
    //   };
    //
    //   context.setOverrides(overrides);
    //
    //   overrides.forEach((experimentName, variant) =>
    //       expect(variant, context.getTreatment(experimentName)));
    //   expect(overrides.length, context.getPendingCount());
    //
    //   // overriding again with the same variant shouldn't clear assignment cache
    //   overrides.forEach((experimentName, variant) {
    //     context.setOverride(experimentName, variant);
    //     expect(variant, context.getTreatment(experimentName));
    //   });
    //   expect(overrides.length, context.getPendingCount());
    //
    //   // overriding with the different variant should clear assignment cache
    //   overrides.forEach((experimentName, variant) {
    //     context.setOverride(experimentName, variant + 11);
    //     expect(variant + 11, context.getTreatment(experimentName));
    //   });
    //
    //   expect(overrides.length * 2, context.getPendingCount());
    //
    //   // overriding a computed assignment should clear assignment cache
    //   expect(
    //       expectedVariants["exp_test_ab"], context.getTreatment("exp_test_ab"));
    //   expect(1 + overrides.length * 2, context.getPendingCount());
    //
    //   context.setOverride("exp_test_ab", 9);
    //   expect(9, context.getTreatment("exp_test_ab"));
    //   expect(2 + overrides.length * 2, context.getPendingCount());
    // });

    test("setOverridesBeforeReady", () {
      final Context context = createContext(null, dataFuture.future);
      expect(false, context.isReady());

      context.setOverride("exp_test", 2);
      context.setOverrides({"exp_test_new": 3, "exp_test_new_2": 5});

      dataFuture.complete(data);

      context.waitUntilReady();

      expect(2, context.getOverride("exp_test"));
      expect(3, context.getOverride("exp_test_new"));
      expect(5, context.getOverride("exp_test_new_2"));
    });

    // test("setCustomAssignment", () {
    //   final Context context = createReadyContext(null);
    //   context.setCustomAssignment("exp_test", 2);
    //
    //   expect(2, context.getCustomAssignment("exp_test"));
    //
    //   context.setCustomAssignment("exp_test", 3);
    //   expect(3, context.getCustomAssignment("exp_test"));
    //
    //   context.setCustomAssignment("exp_test_2", 1);
    //   expect(1, context.getCustomAssignment("exp_test_2"));
    //
    //   final Map<String, int> cassignments = {
    //     "exp_test_new": 3,
    //     "exp_test_new_2": 5
    //   };
    //
    //   context.setCustomAssignments(cassignments);
    //
    //   expect(3, context.getCustomAssignment("exp_test"));
    //   expect(1, context.getCustomAssignment("exp_test_2"));
    //   cassignments.forEach((experimentName, variant) =>
    //       expect(variant, context.getCustomAssignment(experimentName)));
    //
    //   expect(null, context.getCustomAssignment("exp_test_not_found"));
    // });
    //
    // test("setCustomAssignmentDoesNotOverrideFullOnOrNotEligibleAssignments",
    //     () {
    //   final Context context = createReadyContext(null);
    //
    //   context.setCustomAssignment("exp_test_not_eligible", 3);
    //   context.setCustomAssignment("exp_test_fullon", 3);
    //
    //   expect(0, context.getTreatment("exp_test_not_eligible"));
    //   expect(2, context.getTreatment("exp_test_fullon"));
    // });
    //
    // test("setCustomAssignmentClearsAssignmentCache", () {
    //   final Context context = createReadyContext(null);
    //
    //   final Map<String, int> cassignments = {
    //     "exp_test_ab": 2,
    //     "exp_test_abc": 3
    //   };
    //
    //   cassignments.forEach((experimentName, variant) {
    //     expect(expectedVariants[experimentName],
    //         context.getTreatment(experimentName));
    //   });
    //
    //   expect(cassignments.length, context.getPendingCount());
    //
    //   context.setCustomAssignments(cassignments);
    //
    //   cassignments.forEach((experimentName, variant) {
    //     expect(variant, context.getTreatment(experimentName));
    //   });
    //   expect(2 * cassignments.length, context.getPendingCount());
    //
    //   // overriding again with the same variant shouldn't clear assignment cache
    //   cassignments.forEach((experimentName, variant) {
    //     context.setCustomAssignment(experimentName, variant);
    //     expect(variant, context.getTreatment(experimentName));
    //   });
    //   expect(2 * cassignments.length, context.getPendingCount());
    //
    //   // overriding with the different variant should clear assignment cache
    //   cassignments.forEach((experimentName, variant) {
    //     context.setCustomAssignment(experimentName, variant + 11);
    //     expect(variant + 11, context.getTreatment(experimentName));
    //   });
    //
    //   expect(cassignments.length * 3, context.getPendingCount());
    // });

    test("setCustomAssignmentsBeforeReady", () {
      final Context context = createContext(null, dataFuture.future);
      expect(false, context.isReady());

      context.setCustomAssignment("exp_test", 2);
      context.setCustomAssignments({"exp_test_new": 3, "exp_test_new_2": 5});

      dataFuture.complete(data);

      context.waitUntilReady();

      expect(2, context.getCustomAssignment("exp_test"));
      expect(3, context.getCustomAssignment("exp_test_new"));
      expect(5, context.getCustomAssignment("exp_test_new_2"));
    });

    // test("getVariableValue", () {
    //   final Context context = createReadyContext(null);
    //
    //   final Set<String> experiments =
    //       Set.from(data.experiments.map((x) => x.name));
    //
    //   variableExperiments.forEach((variable, experimentNames) {
    //     final String experimentName = experimentNames[0];
    //     final Object actual = context.getVariableValue(variable, 17);
    //     final bool eligible = experimentName != "exp_test_not_eligible";
    //
    //     if (eligible && experiments.contains(experimentName)) {
    //       expect(expectedVariables[variable], actual);
    //     } else {
    //       expect(17, actual);
    //     }
    //   });
    //
    //   expect(experiments.length, context.getPendingCount());
    // });
    //
    // test("getVariableValueConflictingKeyDisjointAudiences", () {
    //   for (final Experiment experiment in data.experiments) {
    //     switch (experiment.name) {
    //       case "exp_test_ab":
    //         assert(expectedVariants[experiment.name] != 0);
    //         experiment.audienceStrict = true;
    //         experiment.audience =
    //             "{\"filter\":[{\"gte\":[{\"var\":\"age\"},{\"value\":20}]}]}";
    //         experiment.variants[expectedVariants[experiment.name]!].config =
    //             "{\"icon\":\"arrow\"}";
    //         break;
    //       case "exp_test_abc":
    //         assert(expectedVariants[experiment.name] != 0);
    //         experiment.audienceStrict = true;
    //         experiment.audience =
    //             "{\"filter\":[{\"lt\":[{\"var\":\"age\"},{\"value\":20}]}]}";
    //         experiment.variants[expectedVariants[experiment.name]!].config =
    //             "{\"icon\":\"circle\"}";
    //         break;
    //       default:
    //         break;
    //     }
    //   }
    //
    //   {
    //     final Context context = createReadyContext(data);
    //     context.setAttribute("age", 20);
    //     expect("arrow", context.getVariableValue("icon", "square"));
    //
    //     expect(1, context.getPendingCount());
    //   }
    //
    //   {
    //     final Context context = createReadyContext(data);
    //     context.setAttribute("age", 19);
    //     expect("circle", context.getVariableValue("icon", "square"));
    //
    //     expect(1, context.getPendingCount());
    //   }
    // });
    //
    // test(
    //     "getVariableValueQueuesExposureWithAudienceMismatchFalseOnAudienceMatch",
    //     () {
    //   final Context context = createContext(null, audienceDataFutureReady);
    //   context.setAttribute("age", 21);
    //
    //   expect("large", context.getVariableValue("banner.size", "small"));
    //   expect(1, context.getPendingCount());
    //
    //   context.publish();
    //
    //   final PublishEvent expected = PublishEvent(
    //       hashed: true,
    //       units: publishUnits,
    //       publishedAt: clock.millis(),
    //       exposures: [
    //         Exposure(
    //             id: 1,
    //             name: "exp_test_ab",
    //             unit: "session_id",
    //             variant: 1,
    //             exposedAt: clock.millis(),
    //             assigned: true,
    //             eligible: true,
    //             overridden: false,
    //             fullOn: false,
    //             custom: false,
    //             audienceMismatch: false),
    //       ],
    //       goals: [],
    //       attributes: [
    //         Attribute(name: "age", value: 21, setAt: clock.millis())
    //       ]);
    //
    //   context.publish();
    //
    //   verify(() {
    //     eventHandler.publish(context, expected);
    //   }).called(1);
    // });
    //
    // test(
    //     "getVariableValueQueuesExposureWithAudienceMismatchTrueOnAudienceMismatch",
    //     () {
    //   final Context context = createContext(null, audienceDataFutureReady);
    //
    //   expect("large", context.getVariableValue("banner.size", "small"));
    //   expect(1, context.getPendingCount());
    //
    //   context.publish();
    //
    //   final PublishEvent expected = PublishEvent(
    //       hashed: true,
    //       units: publishUnits,
    //       publishedAt: clock.millis(),
    //       exposures: [
    //         Exposure(
    //           id: 1,
    //           name: "exp_test_ab",
    //           unit: "session_id",
    //           variant: 1,
    //           exposedAt: clock.millis(),
    //           assigned: true,
    //           eligible: true,
    //           overridden: false,
    //           fullOn: false,
    //           custom: false,
    //           audienceMismatch: true,
    //         )
    //       ],
    //       goals: [],
    //       attributes: []);
    //
    //   context.publish();
    //
    //   verify(() {
    //     eventHandler.publish(context, expected);
    //   }).called(1);
    // });
    //
    // test(
    //     "getVariableValueDoesNotQueuesExposureWithAudienceMismatchFalseAndControlVariantOnAudienceMismatchInStrictMode",
    //     () {
    //   final Context context =
    //       createContext(null, audienceStrictDataFutureReady);
    //
    //   expect("small", context.getVariableValue("banner.size", "small"));
    //   expect(0, context.getPendingCount());
    // });
    //
    // test("getVariableKeys", () {
    //   final Context context = createContext(null, refreshDataFutureReady);
    //
    //   expect(variableExperiments, context.getVariableKeys());
    // });
    //
    // test("getTreatment", () {
    //   final Context context = createReadyContext(null);
    //
    //   data.experiments.forEach((experiment) {
    //     expect(expectedVariants[experiment.name], experiment.variants);
    //   });
    //
    //   expect(0, context.getTreatment("not_found"));
    //   expect(1 + data.experiments.length, context.getPendingCount());
    //
    //   final PublishEvent expected = PublishEvent(
    //     hashed: true,
    //     units: publishUnits,
    //     publishedAt: clock.millis(),
    //     exposures: [
    //       Exposure(
    //         id: 1,
    //         name: "exp_test_ab",
    //         unit: "session_id",
    //         variant: 1,
    //         exposedAt: clock.millis(),
    //         assigned: true,
    //         eligible: true,
    //         overridden: false,
    //         fullOn: false,
    //         custom: false,
    //         audienceMismatch: false,
    //       ),
    //       Exposure(
    //         id: 2,
    //         name: "exp_test_abc",
    //         unit: "session_id",
    //         variant: 2,
    //         exposedAt: clock.millis(),
    //         assigned: true,
    //         eligible: true,
    //         overridden: false,
    //         fullOn: false,
    //         custom: false,
    //         audienceMismatch: false,
    //       ),
    //       Exposure(
    //         id: 3,
    //         name: "exp_test_not_eligible",
    //         unit: "user_id",
    //         variant: 0,
    //         exposedAt: clock.millis(),
    //         assigned: true,
    //         eligible: false,
    //         overridden: false,
    //         fullOn: false,
    //         custom: false,
    //         audienceMismatch: false,
    //       ),
    //       Exposure(
    //         id: 4,
    //         name: "exp_test_fullon",
    //         unit: "session_id",
    //         variant: 2,
    //         exposedAt: clock.millis(),
    //         assigned: true,
    //         eligible: true,
    //         overridden: false,
    //         fullOn: true,
    //         custom: false,
    //         audienceMismatch: false,
    //       ),
    //       Exposure(
    //         id: 0,
    //         name: "not_found",
    //         unit: null,
    //         variant: 0,
    //         exposedAt: clock.millis(),
    //         assigned: false,
    //         eligible: true,
    //         overridden: false,
    //         fullOn: false,
    //         custom: false,
    //         audienceMismatch: false,
    //       ),
    //     ],
    //     goals: [],
    //     attributes: [],
    //   );
    //   expected.hashed = true;
    //   expected.publishedAt = clock.millis();
    //   expected.units = publishUnits;
    //
    //   context.publish();
    //
    //   verify(() {
    //     eventHandler.publish(context, expected);
    //   }).called(1);
    //
    //   context.close();
    // });
    //
    // test("getTreatmentStartsPublishTimeoutAfterExposure", () {
    //   final ContextConfig config =
    //       ContextConfig.create().setUnits(units).setPublishDelay(333);
    //
    //   final Context context = createContext(config, dataFutureReady);
    //   expect(true, context.isReady());
    //   expect(false, context.isFailed());
    //
    //   context.getTreatment("exp_test_ab");
    //   context.getTreatment("exp_test_abc");
    // });
    //
    // test("getTreatmentReturnsOverrideVariant", () {
    //   final Context context = createReadyContext(null);
    //
    //   data.experiments.forEach((experiment) => context.setOverride(
    //       experiment.name, 11 + expectedVariants[experiment.name]!));
    //
    //   context.setOverride("not_found", 3);
    //
    //   data.experiments.forEach((experiment) => expect(
    //       expectedVariants[experiment.name]! + 11,
    //       context.getTreatment(experiment.name)));
    //
    //   expect(3, context.getTreatment("not_found"));
    //   expect(1 + data.experiments.length, context.getPendingCount());
    //
    //   final PublishEvent expected = PublishEvent(
    //     hashed: true,
    //     units: publishUnits,
    //     publishedAt: clock.millis(),
    //     exposures: [
    //       Exposure(
    //         id: 1,
    //         name: "exp_test_ab",
    //         unit: "session_id",
    //         variant: 1,
    //         exposedAt: clock.millis(),
    //         assigned: true,
    //         eligible: true,
    //         overridden: false,
    //         fullOn: false,
    //         custom: false,
    //         audienceMismatch: false,
    //       ),
    //       Exposure(
    //         id: 2,
    //         name: "exp_test_abc",
    //         unit: "session_id",
    //         variant: 2,
    //         exposedAt: clock.millis(),
    //         assigned: true,
    //         eligible: true,
    //         overridden: false,
    //         fullOn: false,
    //         custom: false,
    //         audienceMismatch: false,
    //       ),
    //       Exposure(
    //         id: 3,
    //         name: "exp_test_not_eligible",
    //         unit: "user_id",
    //         variant: 0,
    //         exposedAt: clock.millis(),
    //         assigned: true,
    //         eligible: false,
    //         overridden: false,
    //         fullOn: false,
    //         custom: false,
    //         audienceMismatch: false,
    //       ),
    //       Exposure(
    //         id: 4,
    //         name: "exp_test_fullon",
    //         unit: "session_id",
    //         variant: 2,
    //         exposedAt: clock.millis(),
    //         assigned: true,
    //         eligible: true,
    //         overridden: false,
    //         fullOn: true,
    //         custom: false,
    //         audienceMismatch: false,
    //       ),
    //       Exposure(
    //         id: 0,
    //         name: "not_found",
    //         unit: null,
    //         variant: 0,
    //         exposedAt: clock.millis(),
    //         assigned: false,
    //         eligible: true,
    //         overridden: false,
    //         fullOn: false,
    //         custom: false,
    //         audienceMismatch: false,
    //       ),
    //     ],
    //     goals: [],
    //     attributes: [],
    //   );
    //
    //   context.publish();
    //
    //   verify(() {
    //     eventHandler.publish(context, expected);
    //   }).called(1);
    //
    //   context.close();
    // });
    //
    // test("getTreatmentQueuesExposureOnce", () {
    //   final Context context = createReadyContext(null);
    //
    //   data.experiments
    //       .forEach((experiment) => context.getTreatment(experiment.name));
    //   context.getTreatment("not_found");
    //
    //   expect(1 + data.experiments.length, context.getPendingCount());
    //
    //   // call again
    //   data.experiments
    //       .forEach((experiment) => context.getTreatment(experiment.name));
    //   context.getTreatment("not_found");
    //
    //   expect(1 + data.experiments.length, context.getPendingCount());
    //
    //   context.publish();
    //
    //   expect(0, context.getPendingCount());
    //
    //   data.experiments
    //       .forEach((experiment) => context.getTreatment(experiment.name));
    //   context.getTreatment("not_found");
    //   expect(0, context.getPendingCount());
    //
    //   context.close();
    // });
    //
    // test("getTreatmentQueuesExposureWithAudienceMismatchFalseOnAudienceMatch",
    //     () {
    //   final Context context = createContext(null, audienceDataFutureReady);
    //   context.setAttribute("age", 21);
    //
    //   expect(1, context.getTreatment("exp_test_ab"));
    //   expect(1, context.getPendingCount());
    //
    //   context.publish();
    //
    //   final PublishEvent expected = PublishEvent(
    //       hashed: true,
    //       units: publishUnits,
    //       publishedAt: clock.millis(),
    //       exposures: [
    //         Exposure(
    //             id: 1,
    //             name: "exp_test_ab",
    //             unit: "session_id",
    //             variant: 1,
    //             exposedAt: clock.millis(),
    //             assigned: true,
    //             eligible: true,
    //             overridden: false,
    //             fullOn: false,
    //             custom: false,
    //             audienceMismatch: false),
    //       ],
    //       goals: [],
    //       attributes: [
    //         Attribute(name: "age", value: 21, setAt: clock.millis())
    //       ]);
    //
    //   context.publish();
    //
    //   verify(() {
    //     eventHandler.publish(context, expected);
    //   }).called(1);
    // });
    //
    // test("getTreatmentQueuesExposureWithAudienceMismatchTrueOnAudienceMismatch",
    //     () {
    //   final Context context = createContext(null, audienceDataFutureReady);
    //
    //   expect(1, context.getTreatment("exp_test_ab"));
    //   expect(1, context.getPendingCount());
    //
    //   context.publish();
    //
    //   final PublishEvent expected = PublishEvent(
    //       hashed: true,
    //       units: publishUnits,
    //       publishedAt: clock.millis(),
    //       exposures: [
    //         Exposure(
    //             id: 1,
    //             name: "exp_test_ab",
    //             unit: "session_id",
    //             variant: 0,
    //             exposedAt: clock.millis(),
    //             assigned: false,
    //             eligible: true,
    //             overridden: false,
    //             fullOn: false,
    //             custom: false,
    //             audienceMismatch: true)
    //       ],
    //       goals: [],
    //       attributes: []);
    //
    //   context.publish();
    //
    //   verify(() {
    //     eventHandler.publish(context, expected);
    //   }).called(1);
    // });
    //
    // test(
    //     "getTreatmentQueuesExposureWithAudienceMismatchTrueAndControlVariantOnAudienceMismatchInStrictMode",
    //     () {
    //   final Context context =
    //       createContext(null, audienceStrictDataFutureReady);
    //
    //   expect(0, context.getTreatment("exp_test_ab"));
    //   expect(1, context.getPendingCount());
    //
    //   context.publish();
    //
    //   final PublishEvent expected = PublishEvent(
    //       hashed: true,
    //       units: publishUnits,
    //       publishedAt: clock.millis(),
    //       exposures: [
    //         Exposure(
    //             id: 1,
    //             name: "exp_test_ab",
    //             unit: "session_id",
    //             variant: 0,
    //             exposedAt: clock.millis(),
    //             assigned: false,
    //             eligible: true,
    //             overridden: false,
    //             fullOn: false,
    //             custom: false,
    //             audienceMismatch: true)
    //       ],
    //       goals: [],
    //       attributes: []);
    //
    //   context.publish();
    //
    //   verify(() {
    //     eventHandler.publish(context, expected);
    //   }).called(1);
    // });
  });
}
