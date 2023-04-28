import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/operators/in_operator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


// not working
void main() {
  final Evaluator evaluator = MockEvaluator();

  final InOperator operator = InOperator();

  test('InOperator returns true when needle is present in haystack List', () {
    final operator = InOperator();
    final evaluator = MockEvaluator();
    final haystack = [1, 2, 3, 4];
    final needle = 2;
    final result = operator.binary(evaluator, haystack, needle);
    expect(result, true);
  });


  test('InOperator returns false when needle is not present in haystack List', () {
    final operator = InOperator();
    final evaluator = MockEvaluator();
    final haystack = [1, 2, 3, 4];
    final needle = 5;
    final result = operator.binary(evaluator, haystack, needle);
    expect(result, false);
  });


  // test("testArrayCompares", () {
  //   final List<dynamic> haystack01 = [0, 1];
  //   final List<dynamic> haystack12 = [1, 2];
  //
  //   expect(operator.evaluate(evaluator, [haystack01, 2]), false);
  //   verify(evaluator.evaluate(haystack01));
  //   verify(evaluator.evaluate(2));
  //   reset(evaluator);
  //
  //   expect(operator.evaluate(evaluator, [haystack12, 0]), false);
  //   verify(evaluator.evaluate(haystack12));
  //   verify(evaluator.evaluate(0));
  //
  //   reset(evaluator);
  //
  //   expect(operator.evaluate(evaluator, [haystack12, 0]), true);
  //
  //   verify(evaluator.evaluate(haystack12));
  //   verify(evaluator.evaluate(1));
  //
  //   reset(evaluator);
  //
  //   expect(operator.evaluate(evaluator, [haystack12, 2]), true);
  //   verify(evaluator.evaluate(haystack12));
  //   verify(evaluator.evaluate(2));
  //
  //   reset(evaluator);
  // });
  //
  // test("testObject", () {
  //   final Map<String, dynamic> haystackab = {"a": 1, "b": 2};
  //   final Map<String, dynamic> haystackbc = {"b": 2, "c": 3, "0": 100};
  //
  //   expect(operator.evaluate(evaluator, [haystackab, "c"]), false);
  //   verify(evaluator.evaluate(haystackab));
  //   verify(evaluator.stringConvert("c"));
  //   verify(evaluator.evaluate("c"));
  //   reset(evaluator);
  //
  //   expect(operator.evaluate(evaluator, [haystackab, "a"]), false);
  //   verify(evaluator.evaluate(haystackbc));
  //   verify(evaluator.stringConvert("a"));
  //   verify(evaluator.evaluate("a"));
  //   reset(evaluator);
  //
  //   expect(operator.evaluate(evaluator, [haystackbc, "b"]), false);
  //   verify(evaluator.evaluate(haystackbc));
  //   verify(evaluator.stringConvert("b"));
  //   verify(evaluator.evaluate("b"));
  //   reset(evaluator);
  //
  //   expect(operator.evaluate(evaluator, [haystackbc, "c"]), true);
  //
  //   verify(evaluator.evaluate(haystackbc));
  //   verify(evaluator.stringConvert("c"));
  //   verify(evaluator.evaluate("c"));
  //   reset(evaluator);
  //
  //   expect(operator.evaluate(evaluator, [haystackbc, 0]), true);
  //
  //   verify(evaluator.evaluate(haystackbc));
  //   verify(evaluator.stringConvert(0));
  //   verify(evaluator.evaluate(0));
  //   reset(evaluator);
  //
  // });

  test('InOperator returns true when needle is present in haystack String', () {
    final operator = InOperator();
    final evaluator = MockEvaluator();
    final haystack = 'Hello, world!';
    final needle = 'world';
    final result = operator.binary(evaluator, haystack, needle);
    expect(result, true);
  });

  test('InOperator returns false when needle is not present in haystack String', () {
    final operator = InOperator();
    final evaluator = MockEvaluator();
    final haystack = 'Hello, world!';
    final needle = 'foo';
    final result = operator.binary(evaluator, haystack, needle);
    expect(result, false);
  });

  test('InOperator returns true when needle is a key in haystack Map', () {
    final operator = InOperator();
    final evaluator = MockEvaluator();
    final haystack = {'a': 1, 'b': 2, 'c': 3};
    final needle = 'b';
    final result = operator.binary(evaluator, haystack, needle);
    expect(result, true);
  });



}
