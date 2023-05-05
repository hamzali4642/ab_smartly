import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/equals_operator.dart';
import 'package:flutter_test/flutter_test.dart';

// not working
void main() {
  group('EqualsOperator', () {
    test('should return true when comparing two equal values', () {
      final operator = EqualsOperator();
      final evaluator =
          MockEvaluator(); // replace with your own evaluator implementation
      final lhs = 42;
      final rhs = 42;
      final result = operator.binary(evaluator, lhs, rhs);
      expect(result, isTrue);
    });

    test('should return false when comparing two unequal values', () {
      final operator = EqualsOperator();
      final evaluator =
          MockEvaluator(); // replace with your own evaluator implementation
      const lhs = 'hello';
      const rhs = 'world';
      final result = operator.binary(evaluator, lhs, rhs);
      expect(result, isFalse);
    });

    test('should return null when comparing values of different types', () {
      final operator = EqualsOperator();
      final evaluator =
          MockEvaluator(); // replace with your own evaluator implementation
      final lhs = 42;
      final rhs = '42';
      final result = operator.binary(evaluator, lhs, rhs);
      expect(result, isNull);
    });
  });
}

// void main() {
//   final EqualsOperator operator = EqualsOperator();
//   final Evaluator evaluator = MockEvaluator();
//
//   test("testEvaluate", (){
//     expect(operator.evaluate(evaluator, [0,0]), true);
//     verify(evaluator.evaluate(0));
//     verify(evaluator.evaluate(1));
//     verify(evaluator.compare(1, 0,));
//
//     reset(evaluator);
//
//
//     expect(operator.evaluate(evaluator, [1,0]), false);
//     verify(evaluator.evaluate(0));
//     verify(evaluator.evaluate(1));
//     verify(evaluator.compare(1, 0,));
//
//     reset(evaluator);
//
//
//     expect(operator.evaluate(evaluator, [0, 1]), false);
//     verify(evaluator.evaluate(0));
//     verify(evaluator.evaluate(1));
//     verify(evaluator.compare(0, 1,));
//
//     reset(evaluator);
//
//
//   });
// }
