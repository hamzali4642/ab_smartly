import '../evaluator.dart';
import 'binary_operator.dart';

class LessThanOperator extends BinaryOperator {
  @override
  dynamic binary(Evaluator evaluator, Object lhs, Object rhs) {
    final result = evaluator.compare(lhs, rhs);
    return result != null ? result < 0 : null;
  }
}