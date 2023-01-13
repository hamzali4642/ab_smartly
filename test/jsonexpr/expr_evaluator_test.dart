import 'dart:math';

import 'dart:math';

import 'dart:math';

import 'package:ab_smartly/jsonexpr/evaluator.dart';
import 'package:ab_smartly/jsonexpr/evaluator.mocks.dart';
import 'package:ab_smartly/jsonexpr/expr_evaluator.dart';
import 'package:ab_smartly/jsonexpr/operator.dart';
import 'package:ab_smartly/jsonexpr/operator.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main(){
  var EMPTY_MAP = {};
  var EMPTY_LIST = [];
  final Evaluator ev = MockEvaluator();
  test("testEvaluateConsidersListAsAndCombinator", (){
    final Operator andOperator = MockOperator();
    final Operator orOperator = MockOperator();

    // when(andOperator.evaluate(ev, null)).thenReturn(true);

    final ExprEvaluator evaluator = ExprEvaluator({"and": andOperator, "or": orOperator}, {});

    final List<dynamic> args = [{"value": true}, {"value": false}];


    
  });

  

  test("testEvaluateReturnsNullIfOperatorNotFound", (){
    final Operator valueOperator = MockOperator();

    final ExprEvaluator evaluator = ExprEvaluator({"value": valueOperator}, {});
    expect(evaluator.evaluate({"not_found": true}), null);

  });
  
  test("testEvaluateCallsOperatorWithArgs", (){
    final Operator valueOperator = MockOperator();

    final List<dynamic> args = [1, 2, 3];

    final ExprEvaluator evaluator = ExprEvaluator({"value": valueOperator}, {});
    expect(evaluator.evaluate({"value", args}), args, );
  });

  test("testBooleanConvert", (){
    final ExprEvaluator evaluator = ExprEvaluator({}, {});

    expect(evaluator.booleanConvert(EMPTY_MAP), true);
    expect(evaluator.booleanConvert(EMPTY_LIST), true);
    expect(evaluator.booleanConvert(null), false);

    expect(evaluator.booleanConvert(true), true);
    expect(evaluator.booleanConvert(1), true);
    expect(evaluator.booleanConvert(2), true);
    expect(evaluator.booleanConvert("abc"), true);
    expect(evaluator.booleanConvert("1"), true);

    expect(evaluator.booleanConvert(false), false);
    expect(evaluator.booleanConvert(0), false);
    expect(evaluator.booleanConvert(""), false);
    expect(evaluator.booleanConvert("0"), false);
    expect(evaluator.booleanConvert("false"), false);
  });

  test("testNumberConvertz", (){
    final ExprEvaluator evaluator = ExprEvaluator({}, {});

    expect(evaluator.numberConvert(EMPTY_MAP), null);
    expect(evaluator.numberConvert(EMPTY_LIST), null);
    expect(evaluator.numberConvert(null), null);
    expect(evaluator.numberConvert(""), null);
    expect(evaluator.numberConvert("abcd"), null);
    expect(evaluator.numberConvert("x1234"), null);

    expect(evaluator.numberConvert(true), 1.0);
    expect(evaluator.numberConvert(false), 0.0);

    expect(evaluator.numberConvert(-1.0), -1.0);
    expect(evaluator.numberConvert(0.0), 0.0);
    expect(evaluator.numberConvert(1.0), 1.0);
    expect(evaluator.numberConvert(1.5), 1.5);
    expect(evaluator.numberConvert(2.0), 2.0);
    expect(evaluator.numberConvert(3.0), 3.0);

    expect(evaluator.numberConvert(-1), -1.0);
    expect(evaluator.numberConvert(0), 0.0);
    expect(evaluator.numberConvert(1), 1.0);
    expect(evaluator.numberConvert(2),2.0);
    expect(evaluator.numberConvert(3), 3.0);
    expect(evaluator.numberConvert(2147483647.0), 2147483647.0);
    expect(evaluator.numberConvert(-2147483647.0), -2147483647.0);
    expect(evaluator.numberConvert(9007199254740991), 9007199254740991.0);
    expect(evaluator.numberConvert(-9007199254740991), -9007199254740991.0);

    expect(evaluator.numberConvert("-1"), -1.0);
    expect(evaluator.numberConvert("0"), 0.0);
    expect(evaluator.numberConvert("1"), 1.0);
    expect(evaluator.numberConvert("1.5"), 1.5);
    expect(evaluator.numberConvert("2"), 2.0);
    expect(evaluator.numberConvert("3.0"), 3.0);
  });


  test("testStringConvert", (){
    final ExprEvaluator evaluator = ExprEvaluator({}, {});

    expect(evaluator.stringConvert(null), null);
    expect(evaluator.stringConvert(EMPTY_MAP), null);
    expect(evaluator.stringConvert(EMPTY_LIST), null);

    expect(evaluator.stringConvert(true), "true");
    expect(evaluator.stringConvert(false), "false");

    expect(evaluator.stringConvert(""), "");
    expect(evaluator.stringConvert("abc"), "abc");

    expect(evaluator.stringConvert(-1.0), "-1");
    expect(evaluator.stringConvert(0.0), "0");
    expect(evaluator.stringConvert(1.0), "1");
    expect(evaluator.stringConvert(1.5), "1.5");
    expect(evaluator.stringConvert(2.0), "2.0");
    expect(evaluator.stringConvert(3.0), "3.0");
    expect(evaluator.stringConvert(2147483647.0), "2147483647");
    expect(evaluator.stringConvert(-2147483647.0), "-2147483647");
    expect(evaluator.stringConvert(9007199254740991.0), "9007199254740991");
    expect(evaluator.stringConvert(-9007199254740991.0), "-9007199254740991");
    expect(evaluator.stringConvert(0.9007199254740991), "0.9007199254740991");
    expect(evaluator.stringConvert(-0.9007199254740991), "0.9007199254740991");

    expect( evaluator.stringConvert(-1), "-1");
    expect(evaluator.stringConvert(0), "0");
    expect(evaluator.stringConvert(1), "1");
    expect(evaluator.stringConvert(2), "2");
    expect(evaluator.stringConvert(3), "3");
    expect(evaluator.stringConvert(2147483647), "2147483647");
    expect(evaluator.stringConvert(-2147483647), "-2147483647");
    expect(evaluator.stringConvert(9007199254740991), "9007199254740991");
    expect(evaluator.stringConvert(-9007199254740991), "-9007199254740991");
  });


  test("testExtractVar", (){
    final Map<String, Object> vars = {
      "a" : 1,
      "b" : true,
      "c" : false,
      "d" : [1, 2, 3],
      "e" : [1, {"z": 2}, 3],
      "f" : {"y", {"x": 3, "0": 10}}
    };

    final ExprEvaluator evaluator = ExprEvaluator({}, vars);

    expect( evaluator.extractVar("a"), 1);
    expect( evaluator.extractVar("b"), true);
    expect( evaluator.extractVar("c"), false);
    expect(evaluator.extractVar("d"), [1,2,3]);
    expect(evaluator.extractVar("e"), [1, {"z" : 2}, 3]);
    expect(evaluator.extractVar("f"), [{"y": {"x" : 3, "0" : 10}}]);

    expect(evaluator.extractVar("a/0"), null);
    expect(evaluator.extractVar("a/b"), null);
    expect(evaluator.extractVar("b/0"), null);
    expect(evaluator.extractVar("b/e"), null);

    expect(evaluator.extractVar("d/0"), 1);
    expect(evaluator.extractVar("d/1"), 2);
    expect(evaluator.extractVar("d/2"), 3);
    expect(evaluator.extractVar("d/3"), null);

    expect(evaluator.extractVar("e/0"), 1);
    expect(evaluator.extractVar("e/1/z"), 2);
    expect(evaluator.extractVar("e/2"), 3);
    expect(evaluator.extractVar("e/1/0"), null);

    expect(evaluator.extractVar("f/y"), {"x": 3, "0": 10},);
    expect(evaluator.extractVar("f/y/x"), 3);
    expect(evaluator.extractVar("f/y/0"), 10);
  });

  test("testCompareNull", (){
    final ExprEvaluator evaluator = ExprEvaluator({}, {});

    expect(evaluator.compare(null, null), 0);

    expect(evaluator.compare(null, 0), null);
    expect(evaluator.compare(null, 1), null);
    expect(evaluator.compare(null, true), null);
    expect(evaluator.compare(null, false), null);
    expect(evaluator.compare(null, ""), null);
    expect(evaluator.compare(null, "abc"), null);
    expect(evaluator.compare(null, EMPTY_MAP), null);
    expect(evaluator.compare(null, EMPTY_LIST), null);

    expect(evaluator.compare(0, null), null);
    expect(evaluator.compare(1, null), null);
    expect(evaluator.compare(true, null), null);
    expect(evaluator.compare(false, null), null);
    expect(evaluator.compare("", null), null);
    expect(evaluator.compare("abc", null), null);
    expect(evaluator.compare(EMPTY_MAP, null), null);
    expect(evaluator.compare(EMPTY_LIST, null), null);
  });

  test("testCompareObjects", (){
    final ExprEvaluator evaluator = ExprEvaluator({}, {});

    expect(evaluator.compare(EMPTY_MAP, 0), null);
    expect(evaluator.compare(EMPTY_MAP, 1), null);
    expect(evaluator.compare(EMPTY_MAP, true), null);
    expect(evaluator.compare(EMPTY_MAP, false), null);
    expect(evaluator.compare(EMPTY_MAP, ""), null);
    expect(evaluator.compare(EMPTY_MAP, "abc"), null);
    expect(evaluator.compare(EMPTY_MAP, EMPTY_MAP), 0);
    expect(evaluator.compare({"a": 1}, {"a": 1}), 0);
    expect(evaluator.compare({"a": 1}, {"b": 2}), null);
    expect(evaluator.compare(EMPTY_MAP, EMPTY_LIST), null);

    expect(evaluator.compare(EMPTY_LIST, 0), null);
    expect(evaluator.compare(EMPTY_LIST, 1), null);
    expect(evaluator.compare(EMPTY_LIST, true), null);
    expect(evaluator.compare(EMPTY_LIST, false), null);
    expect(evaluator.compare(EMPTY_LIST, ""), null);
    expect(evaluator.compare(EMPTY_LIST, "abc"), null);
    expect(evaluator.compare(EMPTY_LIST, EMPTY_MAP), null);
    expect(evaluator.compare(EMPTY_LIST, EMPTY_LIST), 0);
    expect(evaluator.compare([1, 2], [1, 2]), 0);
    expect(evaluator.compare([1, 2], [3, 4]), null);
  });

  test("testCompareBooleans", (){
    final ExprEvaluator evaluator = ExprEvaluator({}, {});

    expect(evaluator.compare(false, 0), 0);
    expect(evaluator.compare(false, 1), -1);
    expect(evaluator.compare(false, true), -1);
    expect(evaluator.compare(false, false), 0);
    expect(evaluator.compare(false, ""), 0);
    expect(evaluator.compare(false, "abc"), -1);
    expect(evaluator.compare(false, EMPTY_MAP), -1);
    expect(evaluator.compare(false, EMPTY_LIST), -1);

    expect(evaluator.compare(true, 0), 1);
    expect(evaluator.compare(true, 1), 0);
    expect(evaluator.compare(true, true), 0);
    expect(evaluator.compare(true, false), 1);
    expect(evaluator.compare(true, ""), 1);
    expect(evaluator.compare(true, "abc"), 0);
    expect(evaluator.compare(true, EMPTY_MAP), 0);
    expect(evaluator.compare(true, EMPTY_LIST), 0);
  });

  test("testCompareNumbers", (){
    final ExprEvaluator evaluator = ExprEvaluator({}, {});

    expect(evaluator.compare(0, 0), 0);
    expect(evaluator.compare(0, 1), -1);
    expect(evaluator.compare(0, true), -1);
    expect(evaluator.compare(0, false), 0);
    expect(evaluator.compare(0, ""), null);
    expect(evaluator.compare(0, "abc"), null);
    expect(evaluator.compare(0, EMPTY_MAP), null);
    expect(evaluator.compare(0, EMPTY_LIST), null);

    expect(evaluator.compare(1, 0),1);
    expect(evaluator.compare(1, 1), 0);
    expect(evaluator.compare(1, true), 0);
    expect(evaluator.compare(1, false), 1);
    expect(evaluator.compare(1, ""), null);
    expect(evaluator.compare(1, "abc"), null);
    expect(evaluator.compare(1, EMPTY_MAP), null);
    expect(evaluator.compare(1, EMPTY_LIST), null);

    expect(evaluator.compare(1.0, 1), 0);
    expect(evaluator.compare(1.5, 1), 1);
    expect(evaluator.compare(2.0, 1), 1);
    expect(evaluator.compare(3.0, 1), 1);

    expect(evaluator.compare(1, 1.0), 0);
    expect(evaluator.compare(1, 1.5), -1);
    expect(evaluator.compare(1, 2.0), -1);
    expect(evaluator.compare(1, 3.0),-1);

    expect(evaluator.compare(9007199254740991, 9007199254740991), 0);
    expect(evaluator.compare(0, 9007199254740991), -1);
    expect(evaluator.compare(9007199254740991, 0), 1);

    expect(evaluator.compare(9007199254740991.0, 9007199254740991.0), 0);
    expect(evaluator.compare(0.0, 9007199254740991.0), -1);
    expect(evaluator.compare(9007199254740991.0, 0.0), 1);
  });

  test("testCompareStrings", (){
    final ExprEvaluator evaluator = ExprEvaluator({}, {});

    expect(evaluator.compare("", ""),0);
    expect(evaluator.compare("abc", "abc"),0);
    expect(evaluator.compare("0", 0),0);
    expect(evaluator.compare("1", 1),0);
    expect(evaluator.compare("true", true),0);
    expect(evaluator.compare("false", false),0);
    expect(evaluator.compare("", EMPTY_MAP), null);
    expect(evaluator.compare("abc", EMPTY_MAP), null);
    expect(evaluator.compare("", EMPTY_LIST), null);
    expect(evaluator.compare("abc", EMPTY_LIST), null);

    expect(evaluator.compare("abc", "bcd"), -1);
    expect(evaluator.compare("bcd", "abc"), 1);
    expect(evaluator.compare("0", "1"), -1);
    expect(evaluator.compare("1", "0"), 1);
    expect(evaluator.compare("9", "100"), 8);
    expect(evaluator.compare("100", "9"), 8);
  });

}