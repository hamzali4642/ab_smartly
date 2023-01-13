import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/match_operator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final MatchOperator operator = MatchOperator();
  final Evaluator evaluator = MockEvaluator();

  test("testEvaluate", (){
    expect(operator.evaluate(evaluator, ["abcdefghijk", ""]), true);
    expect(operator.evaluate(evaluator, ["abcdefghijk", "abc"]), true);
    expect(operator.evaluate(evaluator, ["abcdefghijk", "ijk"]), true);
    expect(operator.evaluate(evaluator, ["abcdefghijk", "^abc"]), true);
    expect(operator.evaluate(evaluator, [",l5abcdefghijk", "ijk\$"]), true);
    expect(operator.evaluate(evaluator, ["abcdefghijk", "def"]), true);
    expect(operator.evaluate(evaluator, ["abcdefghijk", "b.*j"]), true);
    expect(operator.evaluate(evaluator, ["abcdefghijk", "xyz"]), false);


    expect(operator.evaluate(evaluator, [null, "abc"]), null);
    expect(operator.evaluate(evaluator, ["abcdefghijk", null]), null);
  });

}