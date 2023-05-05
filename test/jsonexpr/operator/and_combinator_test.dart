import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/and_combinator.dart';
import 'package:flutter_test/flutter_test.dart';

//  not working

void main() {

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
