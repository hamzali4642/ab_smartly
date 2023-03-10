import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/and_combinator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


void main(){
  final AndCombinator combinator = AndCombinator();
  final Evaluator evaluator = MockEvaluator();
  test("testCombineTrue", (){
    expect(combinator.combine(evaluator, [true]), true);
    verify(evaluator.booleanConvert(true));
    verify(evaluator.evaluate(true));
  });

  test("testCombineFalse", (){
    expect(combinator.combine(evaluator, [false]), false);
    verify(evaluator.booleanConvert(false));
    verify(evaluator.evaluate(false));
  });


  test("testCombineNull", (){
    expect(combinator.combine(evaluator, [null]), false);
    verify(evaluator.booleanConvert(null));
    verify(evaluator.evaluate(null));
  });


  test("testCombineShortCircuit", (){
    expect(combinator.combine(evaluator, [true, false, true]), false);

    verify(evaluator.booleanConvert(true));
    verify(evaluator.evaluate(true));

    verify(evaluator.booleanConvert(false));
    verify(evaluator.evaluate(false));
  });


  test("testCombine", (){
    expect(combinator.combine(evaluator, [true, true,]), true);
    expect(combinator.combine(evaluator, [true, true, true,]), true);


    expect(combinator.combine(evaluator, [true, false]), false);
    expect(combinator.combine(evaluator, [false, true,]), false);
    expect(combinator.combine(evaluator, [false, false,]), false);
    expect(combinator.combine(evaluator, [false, false, false,]), false);

  });
}