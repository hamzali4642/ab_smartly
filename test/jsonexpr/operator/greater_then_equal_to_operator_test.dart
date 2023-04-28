import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/greater_then_or_equal_operator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// not working

void main() {
  group('GreaterThenOrEqualOperator', () {
    final operator = GreaterThenOrEqualOperator();

    test('returns true when lhs is greater than or equal to rhs', () {
      final evaluator = MockEvaluator();
      final lhs = 5;
      final rhs = 3;
      expect(operator.binary(evaluator, lhs, rhs), true);
    });

    test('returns true when lhs is equal to rhs', () {
      final evaluator = MockEvaluator();
      final lhs = 5;
      final rhs = 5;
      expect(operator.binary(evaluator, lhs, rhs), true);
    });

    test('returns false when lhs is less than rhs', () {
      final evaluator = MockEvaluator();
      final lhs = 3;
      final rhs = 5;
      expect(operator.binary(evaluator, lhs, rhs), false);
    });

    test('returns null when evaluator cannot compare lhs and rhs', () {
      final evaluator = MockEvaluator();
      final lhs = 'foo';
      final rhs = 5;
      expect(operator.binary(evaluator, lhs, rhs), null);
    });
  });
}