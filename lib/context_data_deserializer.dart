import 'package:ab_smartly/context_data.dart';

abstract class ContextDataDeserializer {
  ContextData deserialize(List<int> bytes, int offset, int length);
}
