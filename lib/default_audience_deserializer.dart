 import 'dart:convert';
import 'audience_deserializer.dart';

 class DefaultAudienceDeserializer implements AudienceDeserializer {
   static final Logger log = Logger('DefaultAudienceDeserializer');

   final JsonDecoder decoder;

   DefaultAudienceDeserializer() : decoder = const JsonDecoder();

   @override
   Map<String, dynamic> deserialize(List<int> bytes, int offset, int length) {
     try {
       return decoder.convert((bytes.sublist(offset, length)));
     } catch (e) {
       log.severe(e);
       return null;
     }
   }
 }