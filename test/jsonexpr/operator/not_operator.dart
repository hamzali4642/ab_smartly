import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/not_operator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {

  final NotOperator operator = NotOperator();
  final Evaluator evaluator = MockEvaluator();
  test("testFalse", (){
    expect(operator.evaluate(evaluator, false), true);
    verify(evaluator.evaluate(false));
    verify(evaluator.booleanConvert(false));
  });

  test("testTrue", (){
    expect(operator.evaluate(evaluator, true), false);
    verify(evaluator.evaluate(true));
    verify(evaluator.booleanConvert(true));
  });

  test("testNull", (){
    expect(operator.evaluate(evaluator, null), true);
    verify(evaluator.evaluate(null));
    verify(evaluator.booleanConvert(null));
  });

}