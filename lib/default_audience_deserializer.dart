import 'dart:convert';
import 'audience_deserializer.dart';

class DefaultAudienceDeserializer implements AudienceDeserializer {
  final JsonDecoder decoder;

  DefaultAudienceDeserializer() : decoder = const JsonDecoder();

  @override
  Map<String, dynamic>? deserialize(List<int> bytes, int offset, int length) {
    try {

      return decoder.convert(bytes.sublist(offset, length));
    } catch (e) {
      print(e);
      return null;
    }
  }
}
