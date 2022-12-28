import 'operator.dart';
import 'expr_evaluator.dart';

class JsonExpr {
  static final Map<String, Operator> operators = {
    // 'and': AndCombinator(),
    // 'or': OrCombinator(),
    // 'value': ValueOperator(),
    // 'var': VarOperator(),
    // 'null': NullOperator(),
    // 'not': NotOperator(),
    // 'in': InOperator(),
    // 'match': MatchOperator(),
    // 'eq': EqualsOperator(),
    // 'gt': GreaterThanOperator(),
    // 'gte': GreaterThanOrEqualOperator(),
    // 'lt': LessThanOperator(),
    // 'lte': LessThanOrEqualOperator(),
  };

  bool evaluateBooleanExpr(Object expr, Map<String, Object> vars) {
   final evaluator = ExprEvaluator(operators, vars);

    return evaluator.booleanConvert(evaluator.evaluate(expr));
  }

  dynamic evaluateExpr(Object expr, Map<String, Object> vars) {
    final evaluator = ExprEvaluator(operators, vars);

    return evaluator.evaluate(expr);
  }
}