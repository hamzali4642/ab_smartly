import '../evaluator.dart';
import 'binary_operator.dart';

class EqualsOperator extends BinaryOperator {
  @override
  dynamic binary(Evaluator evaluator, Object lhs, Object rhs) {
    final result = evaluator.compare(lhs, rhs);
    if (result == null) {
      return null;
    }
    return result != null ? result == 0 : null;
  }
}
