import 'package:ab_smartly/jsonexpr/operators/unary_operator.dart';

import '../evaluator.dart';

class NotOperator extends UnaryOperator {
  @override
  dynamic unary(Evaluator evaluator, Object args) {
    return !evaluator.booleanConvert(args);
  }
}