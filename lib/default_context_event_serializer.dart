// import 'dart:typed_data';
//
// import 'context_event_serializer.dart';
// import 'json/publish_event.dart';
//
// class DefaultContextEventSerializer implements ContextEventSerializer {
//   static final Logger log = Logger("DefaultContextEventSerializer");
//
//   DefaultContextEventSerializer({ObjectWriter? writer}) {
//     if (writer == null) {
//       final objectMapper = ObjectMapper();
//       writer_ = objectMapper.writerFor(PublishEvent);
//     } else {
//       this.writer_ = writer;
//     }
//   }
//
//   @override
//   Uint8List serialize(PublishEvent event) {
//     try {
//       return writer_.writeValueAsBytes(event);
//     } catch (e) {
//       log.error("", e);
//       return null;
//     }
//   }
//
//   ObjectWriter writer_;
// }
