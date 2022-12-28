import '../evaluator.dart';
import '../operator.dart';

class VarOperator implements Operator {
  @override
  dynamic evaluate(Evaluator evaluator, Object path) {
    if (path is Map) {
      path = (path as Map<String, Object>)['path']!;
    }

    return path is String ? evaluator.extractVar(path) : null;
  }
}