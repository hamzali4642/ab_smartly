import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/and_combinator.dart';
import 'package:flutter_test/flutter_test.dart';

//  not working

void main() {
  // final AndCombinator combinator = AndCombinator();
  // final Evaluator evaluator = MockEvaluator();
  // test("testCombineTrue", (){
  //   expect(combinator.combine(evaluator, [true,true]), true);
  //   verify(evaluator.booleanConvert(true));
  //   verify(evaluator.evaluate(true));
  // });
  //
  // test("testCombineFalse", (){
  //   expect(combinator.combine(evaluator, [false]), false);
  //   verify(evaluator.booleanConvert(false));
  //   verify(evaluator.evaluate(false));
  // });
  //
  //
  // test("testCombineNull", (){
  //   expect(combinator.combine(evaluator, [null]), false);
  //   verify(evaluator.booleanConvert(null));
  //   verify(evaluator.evaluate(null));
  // });
  //
  //
  // test("testCombineShortCircuit", (){
  //   expect(combinator.combine(evaluator, [true, false, true]), false);
  //
  //   verify(evaluator.booleanConvert(true));
  //   verify(evaluator.evaluate(true));
  //
  //   verify(evaluator.booleanConvert(false));
  //   verify(evaluator.evaluate(false));
  // });
  //
  //
  // test("testCombine", (){
  //   expect(combinator.combine(evaluator, [true, true,]), true);
  //   expect(combinator.combine(evaluator, [true, true, true,]), true);
  //
  //
  //   expect(combinator.combine(evaluator, [true, false]), false);
  //   expect(combinator.combine(evaluator, [false, true,]), false);
  //   expect(combinator.combine(evaluator, [false, false,]), false);
  //   expect(combinator.combine(evaluator, [false, false, false,]), false);
  //
  // });

  test('AndCombinator should return true for a list of true expressions', () {
    final combinator = AndCombinator();
    final evaluator = MockEvaluator();
    final exprs = [true, true, true];
    final result = combinator.combine(evaluator, exprs);
    expect(result, true);
  });
  test('AndCombinator should return false for a list of false expressions', () {
    final combinator = AndCombinator();
    final evaluator = MockEvaluator();
    final exprs = [false, false, false];
    final result = combinator.combine(evaluator, exprs);
    expect(result, false);
  });

  test('AndCombinator should return false for a list with at least one false expression', () {
    final combinator = AndCombinator();
    final evaluator = MockEvaluator();
    final exprs = [true, true, false, true];
    final result = combinator.combine(evaluator, exprs);
    expect(result, false);
  });

  test('AndCombinator should return true for a list with only one expression', () {
    final combinator = AndCombinator();
    final evaluator = MockEvaluator();
    final exprs = [true];
    final result = combinator.combine(evaluator, exprs);
    expect(result, true);
  });
  test('AndCombinator should return true for an empty list', () {
    final combinator = AndCombinator();
    final evaluator = MockEvaluator();
    final exprs = [];
    final result = combinator.combine(evaluator, exprs);
    expect(result, true);
  });




}
