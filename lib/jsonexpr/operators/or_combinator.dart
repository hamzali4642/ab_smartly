import '../evaluator.dart';
import 'boolean_combinator.dart';

class OrCombinator extends BooleanCombinator {
  @override
  dynamic combine(Evaluator evaluator, List<Object> exprs) {
    for (final expr in exprs) {
      if (evaluator.booleanConvert(evaluator.evaluate(expr))) {
        return true;
      }
    }
    return exprs.isEmpty;
  }
}