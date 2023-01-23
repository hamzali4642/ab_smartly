import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:ab_smartly/variable_parser.dart';

import 'context.dart';

class DefaultVariableParser implements VariableParser {


  DefaultVariableParser() {
    final ObjectMapper objectMapper = new ObjectMapper();
    objectMapper.enable(MapperFeature.USE_STATIC_TYPING);
    this.reader_ = objectMapper
        .readerFor(TypeFactory.defaultInstance().constructMapType(
        HashMap.class, String.class, Object.class));
  }

  @override
  Map<String, dynamic>? parse(Context context, String experimentName,
      String variantName, final String config) {
    try {
      return reader_.readValue(config);
    } on IOException catch (e) {
      print(e);
      return null;
    }
  }

  late ObjectReader reader_;
}