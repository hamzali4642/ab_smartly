import 'dart:collection';

import 'context_event_logger.dart';

class ContextConfig {
  ContextConfig();

  static ContextConfig create() => ContextConfig();

  ContextConfig setUnit(final String unitType, final String uid) {
    units_ ??= {};
    units_[unitType] = uid;
    return this;
  }

  ContextConfig setUnits(final Map<String, String> units) {
    for (final entry in units.entries) {
      setUnit(entry.key, entry.value);
    }
    return this;
  }

  String? getUnit(final String unitType) => units_[unitType];

  Map<String, String> getUnits() => units_;

  ContextConfig setAttribute(final String name, final Object value) {
    attributes_ ??= {};
    attributes_[name] = value;
    return this;
  }

  ContextConfig setAttributes(final Map<String, dynamic> attributes) {
    attributes_;
    attributes_.addAll(attributes);
    return this;
  }

  dynamic getAttribute(final String name) => attributes_[name];

  Map<String, dynamic> getAttributes() => attributes_;

  ContextConfig setOverride(final String experimentName, int variant) {
    overrides_ ??= {};
    overrides_[experimentName] = variant;
    return this;
  }

  ContextConfig setOverrides(final Map<String, int> overrides) {
    overrides_ ??= {};
    overrides_.addAll(overrides);
    return this;
  }

  dynamic getOverride(String experimentName) => overrides_[experimentName];

  Map<String, int> getOverrides() => overrides_;

  ContextConfig setCustomAssignment(String experimentName, int variant) {
    if (cassigmnents_ == null) {
      cassigmnents_ = new HashMap<String, int>();
    }
    cassigmnents_[experimentName] = variant;
    return this;
  }

  ContextConfig setCustomAssignments(Map<String, int> customAssignments) {
    if (cassigmnents_ == null) {
      cassigmnents_ = {};
    }
    cassigmnents_.addAll(customAssignments);
    return this;
  }

  dynamic getCustomAssignment(String experimentName) =>
      cassigmnents_[experimentName];

  Map<String, int> getCustomAssignments() => cassigmnents_;

  ContextEventLogger getEventLogger() => eventLogger_;

  ContextConfig setEventLogger(ContextEventLogger eventLogger) {
    eventLogger_ = eventLogger;
    return this;
  }

  ContextConfig setPublishDelay(int delayMs) {
    publishDelay = delayMs;
    return this;
  }

  int getPublishDelay() => publishDelay;

  ContextConfig setRefreshInterval(int intervalMs) {
    refreshInterval = intervalMs;
    return this;
  }

  int getRefreshInterval() => refreshInterval;

  late Map<String, String> units_;
  late Map<String, dynamic> attributes_;
  late Map<String, int> overrides_;
  late Map<String, int> cassigmnents_;
  late ContextEventLogger eventLogger_;
  int publishDelay = 100;
  int refreshInterval = 0;
}
