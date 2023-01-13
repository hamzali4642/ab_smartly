import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/null_operator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  final NullOperator operator = NullOperator();
  final Evaluator evaluator = MockEvaluator();
  
  test("testNull", (){
    expect(operator.evaluate(evaluator, null), true);
    verify(evaluator.evaluate(null));
  });
  
  test("testNotNull", (){
    expect(operator.evaluate(evaluator, true), false);
    verify(evaluator.evaluate(true));


    expect(operator.evaluate(evaluator, false), false);
    verify(evaluator.evaluate(false));

    expect(operator.evaluate(evaluator, 0), false);
    verify(evaluator.evaluate(0));
  });
}