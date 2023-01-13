import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/value_operator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ValueOperator operator = ValueOperator();
  final Evaluator evaluator = MockEvaluator();
  
  test("testEvaluate", (){
    expect(operator.evaluate(evaluator, 0), 0);
    expect(operator.evaluate(evaluator, 1), 1);
    expect(operator.evaluate(evaluator, true), true);
    expect(operator.evaluate(evaluator, false), false);
    expect(operator.evaluate(evaluator, ""), "");
    expect(operator.evaluate(evaluator, {}), {});
    expect(operator.evaluate(evaluator, []), []);
    expect(operator.evaluate(evaluator, null), null);
  });
}