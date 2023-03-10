import 'dart:convert';
import 'dart:typed_data';

import 'package:ab_smartly/context_event_serializer.dart';
import 'package:ab_smartly/default_context_event_serializer.dart';
import 'package:ab_smartly/json/attribute.dart';
import 'package:ab_smartly/json/exposure.dart';
import 'package:ab_smartly/json/goal_achievement.dart';
import 'package:ab_smartly/json/publish_event.dart';
import 'package:ab_smartly/json/unit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("DefaultContextEventSerializerTest", () {
    test("serialize", () {
      final event = PublishEvent(
        hashed: true,
        units: [
          Unit(type: "session_id", uid: "pAE3a1i5Drs5mKRNq56adA"),
          Unit(type: "user_id",uid: "JfnnlDI7RTiF9RgfG2JNCw"),
        ],
        publishedAt: 123456789,
        exposures: [
          Exposure(id: 1, name: "exp_test_ab", unit: "session_id", variant: 1, exposedAt: 123470000, assigned: true, eligible: true, overridden: false, fullOn: false, custom: false, audienceMismatch: true),
        ],
        goals: [
          GoalAchievement(name: "goal1",  achievedAt :123456000,properties: {
            "amount": 6,
            "value": 5.0,
            "tries": 1,
            "nested": {"value": 5},
            "nested_arr": {"nested": [1, 2, "test"]}
          }),
          GoalAchievement(name: "goal2",  achievedAt :123456789,properties: null),
        ],
        attributes: [
          Attribute(name: "attr1", value: "value1",setAt: 123456000),
          Attribute(name: "attr2", value: "value2", setAt: 123456789),
          Attribute(name: "attr2", value: null, setAt: 123450000),
          Attribute(name: "attr3", value: {"nested": {"value": 5},},setAt: 123470000),
          Attribute(name: "attr4", value: {"nested": [1, 2, "test"]},setAt: 123480000),
        ],
      );

      final ContextEventSerializer ser = DefaultContextEventSerializer();
      final Uint8List bytes = Uint8List.fromList(ser.serialize(event) ?? []);

      expect(utf8.decode(bytes), equals('{"hashed":true,"units":[{"type":"session_id","uid":"pAE3a1i5Drs5mKRNq56adA"},{"type":"user_id","uid":"JfnnlDI7RTiF9RgfG2JNCw"}],"publishedAt":123456789,"exposures":[{"id":1,"name":"exp_test_ab","unit":"session_id","variant":1,"exposedAt":123470000,"assigned":true,"eligible":true,"overridden":false,"fullOn":false,"custom":false,"audienceMismatch":true}],"goals":[{"name":"goal1","achievedAt":123456000,"properties":{"amount":6,"nested":{"value":5},"nested_arr":{"nested":[1,2,"test"]},"tries":1,"value":5.0}},{"name":"goal2","achievedAt":123456789}],"attributes":[{"name":"attr1","value":"value1","setAt":123456000},{"name":"attr2","value":"value2","setAt":123456789},{"name":"attr2","setAt":123450000},{"name":"attr3","value":{"nested":{"value":5}},"setAt":123470000},{"name":"attr4","value":{"nested":[1,2,"test"]},"setAt":123480000}]}'));

    });

    test('serializeDoesNotThrow', () {
      final event = PublishEvent(hashed: true, units: [], publishedAt: 12312, exposures: [], goals: [], attributes: []);
      when(utf8.encode(jsonEncode(event.toMap()))).thenThrow(Exception());
      final ser = DefaultContextEventSerializer();
      expect(() {
        final bytes = ser.serialize(event);
        expect(bytes, isNull);
      }, returnsNormally);
    });
  });
}
