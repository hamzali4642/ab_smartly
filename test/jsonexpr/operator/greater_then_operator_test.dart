import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/greater_then_operator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  final GreaterThenOperator operator = GreaterThenOperator();
  final Evaluator evaluator = MockEvaluator();

  test("testEvaluate", (){
    expect(operator.evaluate(evaluator, [0,0]), false);
    verify(evaluator.evaluate(0));
    verify(evaluator.compare(0, 0,));

    reset(evaluator);


    expect(operator.evaluate(evaluator, [1,0]), false);
    verify(evaluator.evaluate(0));
    verify(evaluator.evaluate(1));
    verify(evaluator.compare(1, 0,));

    reset(evaluator);


    expect(operator.evaluate(evaluator, [0, 1]), false);
    verify(evaluator.evaluate(0));
    verify(evaluator.evaluate(1));
    verify(evaluator.compare(0, 1,));

    reset(evaluator);


  });
}