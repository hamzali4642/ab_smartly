import '../evaluator.dart';
import 'binary_operator.dart';

class InOperator extends BinaryOperator {
  @override
  dynamic binary(Evaluator evaluator, Object haystack, Object needle) {
    if (haystack is List) {
      for (final item in haystack as List<Object>) {
        if (evaluator.compare(item, needle) == 0) {
          return true;
        }
      }
      return false;
    } else if (haystack is String) {
      final needleString = evaluator.stringConvert(needle);
      return needleString != null && (haystack as String).contains(needleString);
    } else if (haystack is Map) {
      final needleString = evaluator.stringConvert(needle);
      return needleString != null && (haystack as Map<String, Object>).containsKey(needleString);
    }
    return null;
  }
}


