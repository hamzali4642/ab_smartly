import 'context_data.dart';
import 'context_data_deserializer.dart';

 class DefaultContextDataDeserializer implements ContextDataDeserializer {
   static final Logger log = Logger("DefaultContextDataDeserializer");

   DefaultContextDataDeserializer() {
     final objectMapper = ObjectMapper();
     objectMapper.enable(MapperFeature.USE_STATIC_TYPING);
     reader_ = objectMapper.readerFor(ContextData);
   }

   @override
  ContextData deserialize(final List<int> bytes, final int offset, final int length) {
     try {
       return reader_.readValue(bytes, offset, length);
     } catch (e) {
       log.error("", e);
       return null;
     }
   }

   late ObjectReader reader_;
 }