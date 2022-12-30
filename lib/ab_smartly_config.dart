import 'dart:async';
import 'package:ab_smartly/variable_parser.dart';
import 'audience_deserializer.dart';
import 'context_data_provider.dart';
import 'context_event_handler.dart';
import 'context_event_logger.dart';
import 'client.dart';

class ABSmartlyConfig{


   static ABSmartlyConfig create() {
    return ABSmartlyConfig();
  }

  ABSmartlyConfig();

   ContextDataProvider getContextDataProvider() {
    return contextDataProvider_;
  }

   ABSmartlyConfig setContextDataProvider( ContextDataProvider contextDataProvider) {
    contextDataProvider_ = contextDataProvider;
    return this;
  }

   ContextEventHandler getContextEventHandler() {
    return contextEventHandler_;
  }

   ABSmartlyConfig setContextEventHandler(ContextEventHandler contextEventHandler) {
    contextEventHandler_ = contextEventHandler;
    return this;
  }

   VariableParser getVariableParser() {
    return variableParser_;
  }

   ABSmartlyConfig setVariableParser( VariableParser variableParser) {
    variableParser_ = variableParser;
    return this;
  }

   // ScheduledExecutorService getScheduler() {
   Timer getScheduler() {

     return scheduler_;
  }

   //ABSmartlyConfig setScheduler( ScheduledExecutorService scheduler) {
   ABSmartlyConfig setScheduler( Timer scheduler) {
    scheduler_ = scheduler;
    return this;
  }

   ContextEventLogger getContextEventLogger() {
    return contextEventLogger_;
  }

   ABSmartlyConfig setContextEventLogger(ContextEventLogger logger) {
    contextEventLogger_ = logger;
    return this;
  }

   AudienceDeserializer getAudienceDeserializer() {
    return audienceDeserializer_;
  }

   ABSmartlyConfig setAudienceDeserializer( AudienceDeserializer audienceDeserializer) {
    audienceDeserializer_ = audienceDeserializer;
    return this;
  }

   Client getClient() {
    return client_;
  }

   ABSmartlyConfig setClient(Client client) {
    client_ = client;
    return this;
  }


  late ContextDataProvider contextDataProvider_;
  late ContextEventHandler contextEventHandler_;

  late ContextEventLogger contextEventLogger_;
  late VariableParser variableParser_;

  late AudienceDeserializer audienceDeserializer_;
 // late ScheduledExecutorService scheduler_;
  late Client client_;

  late Timer scheduler_;

  void scheduleTask() {
    scheduler_ = Timer(const Duration(seconds: 5), () {
    });
  }

}