import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/var_operator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  VarOperator operator = VarOperator();
  final Evaluator evaluator = MockEvaluator();


  test("testEvaluate", (){
    expect(operator.evaluate(evaluator, "a/b/c"), "abc");
    verify(evaluator.extractVar("a/b/c"));
  });
}