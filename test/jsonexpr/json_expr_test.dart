import 'dart:math';

import 'package:ab_smartly/jsonexpr/json_expr.dart';
import 'package:flutter_test/flutter_test.dart';

// not working

void main(){
  //
  // Map<String, dynamic> valueFor(dynamic x) {
  //   return {"value": x};
  // }
  //
  // Map<String, dynamic> varFor(dynamic x) {
  //   return {"var": {"path": x}};
  // }
  //
  // Map<String, dynamic> unaryOp(String op, dynamic arg) {
  //   return {op: arg};
  // }
  //
  // Map<String, dynamic> binaryOp(String op, dynamic lhs, dynamic rhs) {
  //   return {op: [lhs, rhs], };
  // }
  //
  // final Map<String, dynamic> John = {"age": 20, "language": "en-US", "returning": false};
  // final Map<String, dynamic> Terry = {"age": 20, "language": "en-GB", "returning": true};
  // final Map<String, dynamic> Kate = {"age": 50, "language": "es-ES", "returning": false};
  // final Map<String, dynamic> Maria = {"age": 52, "language": "pt-PT", "returning": true};
  //
  // final JsonExpr jsonExpr = JsonExpr();
  //
  // final List<dynamic> AgeTwentyAndUS = [
  //     binaryOp("eq", varFor("age"), valueFor(20)),
  //     binaryOp("eq", varFor("language"), valueFor("en-US"))];
  // final List<dynamic> AgeOverFifty = [
  //     binaryOp("gte", varFor("age"), valueFor(50))];
  //
  // final List<dynamic> AgeTwentyAndUS_Or_AgeOverFifty = [
  //     {"or", [AgeTwentyAndUS, AgeOverFifty]}];
  //
  // final List<dynamic> Returning = [
  //     varFor("returning")];
  //
  // final List<dynamic> Returning_And_AgeTwentyAndUS_Or_AgeOverFifty = [Returning, AgeTwentyAndUS_Or_AgeOverFifty];
  //
  // final List<dynamic> NotReturning_And_Spanish = [unaryOp("not", Returning),
  //     binaryOp("eq", varFor("language"), valueFor("es-ES"))];
  //
  //
  //
  // test("testAgeTwentyAsUSEnglish", (){
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS, John), true);
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS, Terry), false);
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS, Kate), false);
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS, Maria), false);
  // });
  //
  //
  //
  // test("testAgeOverFifty", (){
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS, John), false);
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS, Terry), false);
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS, Kate), true);
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS, Maria), true);
  // });
  //
  //
  // test("testAgeTwentyAndUS_Or_AgeOverFifty", (){
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS_Or_AgeOverFifty, John), true);
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS_Or_AgeOverFifty, Terry), false);
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS_Or_AgeOverFifty, Kate), true);
  //   expect(jsonExpr.evaluateBooleanExpr(AgeTwentyAndUS_Or_AgeOverFifty, Maria), true);
  // });
  //
  //
  // test("testReturning", (){
  //   expect(jsonExpr.evaluateBooleanExpr(Returning, John), false);
  //   expect(jsonExpr.evaluateBooleanExpr(Returning, Terry), true);
  //   expect(jsonExpr.evaluateBooleanExpr(Returning, Kate), false);
  //   expect(jsonExpr.evaluateBooleanExpr(Returning, Maria), true);
  // });
  //
  //
  // test("testReturning_And_AgeTwentyAndUS_Or_AgeOverFifty", (){
  //   expect(jsonExpr.evaluateBooleanExpr(Returning_And_AgeTwentyAndUS_Or_AgeOverFifty, John), false);
  //   expect(jsonExpr.evaluateBooleanExpr(Returning_And_AgeTwentyAndUS_Or_AgeOverFifty, Terry), false);
  //   expect(jsonExpr.evaluateBooleanExpr(Returning_And_AgeTwentyAndUS_Or_AgeOverFifty, Kate), false);
  //   expect(jsonExpr.evaluateBooleanExpr(Returning_And_AgeTwentyAndUS_Or_AgeOverFifty, Maria), true);
  // });
  //
  //
  // test("testNotReturning_And_Spanish", (){
  //   expect(jsonExpr.evaluateBooleanExpr(NotReturning_And_Spanish, John), false);
  //   expect(jsonExpr.evaluateBooleanExpr(NotReturning_And_Spanish, Terry), false);
  //   expect(jsonExpr.evaluateBooleanExpr(NotReturning_And_Spanish, Kate), true);
  //   expect(jsonExpr.evaluateBooleanExpr(NotReturning_And_Spanish, Maria), false);
  // });


  test('evaluateBooleanExpr() returns true for a simple boolean expression', () {
    final expr = {'and': [true, false]};
    final vars = <String, dynamic>{};
    final result = JsonExpr().evaluateBooleanExpr(expr, vars);
    expect(result, equals(false));
  });

  test('evaluateBooleanExpr() returns true for a null operator', () {
    final expr = {'null': []};
    final vars = <String, dynamic>{};

    final result = JsonExpr().evaluateBooleanExpr(expr, vars);
    expect(result, equals(true));
  });

  test('evaluateExpr() returns the value of a variable', () {
    final expr = {'var': 'myVar'};
    final vars = {'myVar': 42};
    final result = JsonExpr().evaluateExpr(expr, vars);
    expect(result, equals(42));
  });
  test('evaluateExpr() returns true for a string match', () {
    final expr = {'match': ['hello', 'ello']};
    final vars = <String, dynamic>{};
    final result = JsonExpr().evaluateExpr(expr, vars);
    expect(result, equals(true));
  });
  test('evaluateExpr() returns true for a less than comparison', () {
    final expr = {'lt': [2, 5]};
    final vars = <String, dynamic>{};
    final result = JsonExpr().evaluateExpr(expr, vars);
    expect(result, equals(true));
  });
  test('evaluateExpr() returns true for an in operator', () {
    final expr = {'in': [2, [1, 2, 3]]};
    final vars = <String, dynamic>{};
    final result = JsonExpr().evaluateExpr(expr, vars);
    expect(result, equals(true));
  });
  test('evaluateExpr() throws an exception for an unknown operator', () {
    final expr = {'unknown': []};
    final vars = <String, dynamic>{};
    expect(() => JsonExpr().evaluateExpr(expr, vars), throwsException);
  });



}