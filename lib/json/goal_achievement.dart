import 'dart:ui';

import 'package:flutter/foundation.dart';

class GoalAchievement {
  String name;
  int achievedAt;
  Map<String, dynamic> properties;

  GoalAchievement({required this.name, required this.achievedAt, required this.properties});

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is GoalAchievement &&
        achievedAt == other.achievedAt &&
        name == other.name &&
        mapEquals(properties, other.properties);
  }

  @override
  int get hashCode => hashValues(name, achievedAt, properties);

  @override
  String toString() {
    return 'GoalAchievement{name: $name, achievedAt: $achievedAt, properties: $properties}';
  }
}