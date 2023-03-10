
import 'package:ab_smartly/audience_matcher.dart';
import 'package:ab_smartly/default_audience_deserializer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final matcher = AudienceMatcher(DefaultAudienceDeserializer());


  group('AudienceMatcherTest', () {
    test('evaluateReturnsNullOnEmptyAudience', () {
      expect(matcher.evaluate('', null), isNull);
      expect(matcher.evaluate('{}', null), isNull);
      expect(matcher.evaluate('null', null), isNull);
    });

    test('evaluateReturnsNullIfFilterNotMapOrList', () {
      expect(matcher.evaluate('{"filter":null}', null), isNull);
      expect(matcher.evaluate('{"filter":false}', null), isNull);
      expect(matcher.evaluate('{"filter":5}', null), isNull);
      expect(matcher.evaluate('{"filter":"a"}', null), isNull);
    });

    test('evaluateReturnsBoolean', () {
      expect(matcher.evaluate('{"filter":[{"value":5}]}', null), isTrue);
      expect(matcher.evaluate('{"filter":[{"value":true}]}', null), isTrue);
      expect(matcher.evaluate('{"filter":[{"value":1}]}', null), isTrue);
      expect(matcher.evaluate('{"filter":[{"value":null}]}', null), isFalse);
      expect(matcher.evaluate('{"filter":[{"value":0}]}', null), isFalse);

      expect(
          matcher.evaluate('{"filter":[{"not":{"var":"returning"}}]}', {'returning': true}),
          isFalse);
      expect(
          matcher.evaluate('{"filter":[{"not":{"var":"returning"}}]}', {'returning': false}),
          isTrue);
    });
  });


}