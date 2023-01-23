import 'dart:core';
import 'context_data_deserializer.dart';
import 'context_event_serializer.dart';
import 'executor.dart';

class ClientConfig {
  static ClientConfig create() {
    return ClientConfig();
  }

  static ClientConfig createFromProperties(Properties properties,
      [String? prefix]) {
    if (prefix == null) {
      return createFromProperties(properties, "");
    } else {
      return create()
          .setEndpoint(properties.getProperty("${prefix}endpoint"))
          .setEnvironment(properties.getProperty("${prefix}environment"))
          .setApplication(properties.getProperty("${prefix}application"))
          .setAPIKey(properties.getProperty("${prefix}apikey"));
    }
  }

  ClientConfig();

  String getEndpoint() {
    return endpoint_;
  }

  ClientConfig setEndpoint(String endpoint) {
    endpoint_ = endpoint;
    return this;
  }

  String getAPIKey() {
    return apiKey_;
  }

  ClientConfig setAPIKey(String apiKey) {
    apiKey_ = apiKey;
    return this;
  }

  String getEnvironment() {
    return environment_;
  }

  ClientConfig setEnvironment(String environment) {
    environment_ = environment;
    return this;
  }

  String getApplication() {
    return application_;
  }

  ClientConfig setApplication(String application) {
    application_ = application;
    return this;
  }

  ContextDataDeserializer getContextDataDeserializer() {
    return deserializer_;
  }

  ClientConfig setContextDataDeserializer(
      ContextDataDeserializer deserializer) {
    deserializer_ = deserializer;
    return this;
  }

  ContextEventSerializer getContextEventSerializer() {
    return serializer_;
  }

  ClientConfig setContextEventSerializer(ContextEventSerializer serializer) {
    serializer_ = serializer;
    return this;
  }

  Executor getExecutor() {
    return executor_;
  }

  ClientConfig setExecutor(Executor executor) {
    executor_ = executor;
    return this;
  }

  late String endpoint_;
  late String apiKey_;
  late String environment_;
  late String application_;
  late final Executor executor_;
  late ContextDataDeserializer deserializer_;
  late ContextEventSerializer serializer_;
}
