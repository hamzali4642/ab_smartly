import '../evaluator.dart';
import 'binary_operator.dart';

class InOperator extends BinaryOperator {
  @override
  dynamic binary(Evaluator evaluator, dynamic haystack, dynamic needle) {
    if (haystack is List) {
      for (final item in haystack as List<dynamic>) {
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
      return needleString != null && (haystack as Map<String, dynamic>).containsKey(needleString);
    }
    return null;
  }
}


