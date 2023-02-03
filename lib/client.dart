import 'dart:typed_data';
import 'package:ab_smartly/default_http_client.dart';
import 'client_config.dart';
import 'context_data.dart';
import 'default_context_data_serializer.dart';
import 'default_context_event_serializer.dart';
import 'java_system_classes/closeable.dart';
import 'context_data_deserializer.dart';
import 'context_event_serializer.dart';
import 'executor.dart';
import 'http_client.dart';
import 'json/publish_event.dart';

class Client implements Closeable {
  static Client create(ClientConfig config, {HTTPClient? httpClient}) {
    if (httpClient == null) {
      return Client(
          config, DefaultHTTPClient.create(DefaultHTTPClientConfig.create()));
    } else {
      return Client(config, httpClient);
    }
  }

  Client(ClientConfig config, HTTPClient httpClient) {
    final String?  endpoint = config.endpoint_;
    if ((endpoint == null) || endpoint.isEmpty) {
      throw ArgumentError("Missing Endpoint configuration");
    }

    final String apiKey = config.apiKey_;
    if ((apiKey == null) || apiKey.isEmpty) {
      throw ArgumentError("Missing APIKey configuration");
    }

    final String application = config.application_;
    if ((application == null) || application.isEmpty) {
      throw ArgumentError("Missing Application configuration");
    }

    final String environment = config.environment_;
    if ((environment == null) || environment.isEmpty) {
      throw ArgumentError("Missing Environment configuration");
    }

    url_ = "$endpoint/context";
    httpClient_ = httpClient;
    deserializer_ = config.contextDataDeserializer;
    serializer_ = config.contextEventSerializer;
    executor_ = config.executor;

    if (deserializer_ == null) {
      deserializer_ = DefaultContextDataDeserializer();
    }

    if (serializer_ == null) {
      serializer_ = DefaultContextEventSerializer();
    }

    headers_ = {
      "X-API-Key": apiKey,
      "X-Application": application,
      "X-Environment": environment,
      "X-Application-Version": "0",
      "X-Agent": "absmartly-java-sdk",
    };

    query_ = {
      "application": application,
      "environment": environment,
    };
  }

  Future<ContextData> getContextData() {
    final CompletableFuture<ContextData> dataFuture =
        CompletableFuture<ContextData>();
    final Executor executor =
        executor_ != null ? executor_ : dataFuture.defaultExecutor();

    CompletableFuture.runAsync(() {
      httpClient_.get(url_, query_, null).then((response) {
        final int code = response.statusCode;
        if ((code / 100) == 2) {
          final Uint8List content = response.content;
          dataFuture.complete(
              deserializer_.deserialize(response.content, 0, content.length));
        } else {
          dataFuture.completeError(Exception(response.statusMessage));
        }
      }).catchError((exception) {
        dataFuture.completeError(exception);
      });
    }, executor);

    return dataFuture;
  }

  Future<void> publish(final PublishEvent event) {
    final CompletableFuture<void> publishFuture = CompletableFuture<void>();
    final Executor executor =
        executor_ != null ? executor_ : publishFuture.defaultExecutor();

    CompletableFuture.supplyAsync(() => serializer_.serialize(event), executor)
        .thenCompose(
            (content) => httpClient_.put(url_, null, headers_, content))
        .then((response) {
      final int code = response.statusCode;
      if ((code / 100) == 2) {
        publishFuture.complete();
      } else {
        publishFuture.completeError(Exception(response.statusMessage));
      }
    }).catchError((exception) {
      publishFuture.completeError(exception);
    });

    return publishFuture;
  }

  @override
  void close() {
    try {
      httpClient_.close();
    } catch (e) {
      rethrow;
    }
  }

  late final String url_;
  late final Map<String, String> query_;
  late final Map<String, String> headers_;
  late final HTTPClient httpClient_;
  late final Executor executor_;
  late ContextDataDeserializer deserializer_;
  late ContextEventSerializer serializer_;
}
