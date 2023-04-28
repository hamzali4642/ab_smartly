import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/greater_then_operator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// not working
void main() {
  group('GreaterThenOperator', () {
    test('returns true when lhs > rhs', () {
      final operator = GreaterThenOperator();
      final evaluator = MockEvaluator();
      final lhs = 5;
      final rhs = 3;
      final result = operator.binary(evaluator, lhs, rhs);
      expect(result, isTrue);
    });

    test('returns false when lhs < rhs', () {
      final operator = GreaterThenOperator();
      final evaluator = MockEvaluator();
      final lhs = 3;
      final rhs = 5;
      final result = operator.binary(evaluator, lhs, rhs);
      expect(result, isFalse);
    });

    test('returns null when lhs == rhs', () {
      final operator = GreaterThenOperator();
      final evaluator = MockEvaluator();
      final lhs = 5;
      final rhs = 5;
      final result = operator.binary(evaluator, lhs, rhs);
      expect(result, isNull);
    });
  });
}