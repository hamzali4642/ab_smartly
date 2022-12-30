library ab_smartly;

import 'dart:async';

import 'package:ab_smartly/variable_parser.dart';

import 'ab_smartly_config.dart';
import 'audience_deserializer.dart';
import 'context_data.dart';
import 'context_data_provider.dart';
import 'context_event_handler.dart';
import 'context_event_logger.dart';
import 'default_audience_deserializer.dart';
import 'default_context_data_provider.dart';
import 'default_context_event_handler.dart';
import 'default_variable_parser.dart';
import 'java_system_classes/closeable.dart';
import 'client.dart';

class ABSmartly implements Closeable {
  ABSmartly(ABSmartlyConfig config) {
    contextDataProvider_ = config.getContextDataProvider();
    contextEventHandler_ = config.getContextEventHandler();
    contextEventLogger_ = config.getContextEventLogger();
    variableParser_ = config.getVariableParser();
    audienceDeserializer_ = config.getAudienceDeserializer();
    scheduler_ = config.getScheduler();

    if ((contextDataProvider_ == null) || (contextEventHandler_ == null)) {
      client_ = config.getClient();
      if (client_ == null) {
        throw Exception("Missing Client instance");
      }

      if (contextDataProvider_ == null) {
        contextDataProvider_ = DefaultContextDataProvider(client_!);
      }

      if (contextEventHandler_ == null) {
        contextEventHandler_ = DefaultContextEventHandler(client_!);
      }
    }

    if (variableParser_ == null) {
      variableParser_ = DefaultVariableParser();
    }

    if (audienceDeserializer_ == null) {
        audienceDeserializer_ =  DefaultAudienceDeserializer();
    }

    if (scheduler_ == null) {
      // scheduler_ = new ScheduledThreadPoolExecutor(1);
    }
  }

  //  Context createContext(ContextConfig config) {
  //   return Context.create(Clock.systemUTC(), config, scheduler_, contextDataProvider_.getContextData(),
  //       contextDataProvider_, contextEventHandler_, contextEventLogger_, variableParser_,
  //       new AudienceMatcher(audienceDeserializer_));
  // }

  // Context createContextWith(ContextConfig config, ContextData data) {
  //   return Context.create(Clock.systemUTC(), config, scheduler_, CompletableFuture.completedFuture(data),
  //       contextDataProvider_, contextEventHandler_, contextEventLogger_, variableParser_,
  //       new AudienceMatcher(audienceDeserializer_));
  // }

  Future<ContextData> getContextData() {
    return contextDataProvider_.getContextData();
  }

  @override
  void close() {
    // if (client_ != null) {
    //   client_!.close();
    //   client_ = null;
    // }
    //
    // if (scheduler_ != null) {
    //   try {
    //     scheduler_.awaitTermination(5000, TimeUnit.MILLISECONDS);
    //   }
    // catch
    // (
    // InterruptedException
    // ignored) {}
    // scheduler_ = null;
    // }
    client_?.close();
  }

  Client? client_;
  late ContextDataProvider contextDataProvider_;
  late ContextEventHandler contextEventHandler_;
  late ContextEventLogger contextEventLogger_;
  late VariableParser variableParser_;
  late AudienceDeserializer audienceDeserializer_;

  //late ScheduledExecutorService scheduler_;

  late Timer scheduler_;

  void scheduleTask() {
    scheduler_ = Timer(const Duration(seconds: 5), () {});
  }
}
