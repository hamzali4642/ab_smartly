import 'context.dart';

abstract class VariableParser {
  Map<String, Object> parse(Context context, String experimentName,
      String variantName, String variableValue);
}
