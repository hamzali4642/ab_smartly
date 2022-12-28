abstract class Evaluator {
  dynamic evaluate(Object expr);

  bool booleanConvert(Object x);

  num numberConvert(Object x);

  String stringConvert(Object x);

  dynamic extractVar(String path);

  dynamic compare(Object lhs, Object rhs);
}