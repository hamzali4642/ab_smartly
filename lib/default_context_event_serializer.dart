import 'context_event_serializer.dart';
import 'json/publish_event.dart';

class DefaultContextEventSerializer implements ContextEventSerializer {
  static final Logger log = Logger("DefaultContextEventSerializer");

  DefaultContextEventSerializer({ObjectWriter? writer}) {
    if (writer == null) {
      final objectMapper = ObjectMapper();
      writer_ = objectMapper.writerFor(PublishEvent);
    } else {
      writer_ = writer;
    }
  }

  @override
  List<int>? serialize(PublishEvent event) {
    try {
      return writer_.writeValueAsBytes(event);
    } catch (e) {
      print(e);
      return null;
    }
  }

  ObjectWriter writer_;
}
