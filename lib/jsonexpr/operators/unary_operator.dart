import '../evaluator.dart';
import '../operator.dart';

abstract class UnaryOperator implements Operator {
  @override
  dynamic evaluate(Evaluator evaluator, Object args) {
    final arg = evaluator.evaluate(args);
    return unary(evaluator, arg);
  }

  dynamic unary(Evaluator evaluator, Object arg);
}

class NotOperator extends UnaryOperator {
  @override
  Object unary(Evaluator evaluator, Object args) {
    return !evaluator.booleanConvert(args);
  }
}