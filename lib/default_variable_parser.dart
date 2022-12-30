import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:ab_smartly/variable_parser.dart';

class DefaultVariableParser implements VariableParser {
  static final Logger log = LoggerFactory.getLogger(
      DefaultVariableParser.class);

  DefaultVariableParser() {
    final ObjectMapper objectMapper = new ObjectMapper();
    objectMapper.enable(MapperFeature.USE_STATIC_TYPING);
    this.reader_ = objectMapper
        .readerFor(TypeFactory.defaultInstance().constructMapType(
        HashMap.class, String.class, Object.class));
  }

  @override
  Map<String, Object> parse(Context context, String experimentName,
      String variantName, final String config) {
    try {
      return reader_.readValue(config);
    } on IOException catch (e) {
      log.error("", e);
      return null;
    }
  }

  late ObjectReader reader_;
}