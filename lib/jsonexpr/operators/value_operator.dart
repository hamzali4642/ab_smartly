import '../evaluator.dart';
import '../operator.dart';

class ValueOperator implements Operator {
  @override
  dynamic evaluate(Evaluator evaluator, Object value) {
    return value;
  }
}