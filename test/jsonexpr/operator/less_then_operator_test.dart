import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/greater_then_operator.dart';
import 'package:ab_smartly/jsonexpr/operators/less_then_operator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


// not working
void main() {
  final LessThenOperator operator = LessThenOperator();
  final Evaluator evaluator = MockEvaluator();

  // test("testEvaluate", (){
  //   expect(operator.evaluate(evaluator, [0,0]), false);
  //   verify(evaluator.evaluate(0));
  //   verify(evaluator.compare(0, 0,));
  //
  //   reset(evaluator);
  //
  //
  //   expect(operator.evaluate(evaluator, [1,0]), false);
  //   verify(evaluator.evaluate(0));
  //   verify(evaluator.evaluate(1));
  //   verify(evaluator.compare(1, 0,));
  //
  //   reset(evaluator);
  //
  //
  //   expect(operator.evaluate(evaluator, [0, 1]), false);
  //   verify(evaluator.evaluate(0));
  //   verify(evaluator.evaluate(1));
  //   verify(evaluator.compare(0, 1,));
  //
  //   reset(evaluator);
  //
  //
  // });
  group('LessThenOperator', () {
    final evaluator = MockEvaluator();
    final operator = LessThenOperator();

    test('should return true when lhs is less than rhs', () {
      final lhs = 5;
      final rhs = 10;
      expect(operator.binary(evaluator, lhs, rhs), true);
    });

    test('should return false when lhs is greater than rhs', () {
      final lhs = 10;
      final rhs = 5;
      expect(operator.binary(evaluator, lhs, rhs), false);
    });

    test('should return false when lhs is equal to rhs', () {
      final lhs = 5;
      final rhs = 5;
      expect(operator.binary(evaluator, lhs, rhs), false);
    });

    test('should return null when evaluator cannot compare lhs and rhs', () {
      final lhs = 'hello';
      final rhs = 5;
      expect(operator.binary(evaluator, lhs, rhs), null);
    });
  });

}