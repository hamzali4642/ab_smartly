import 'dart:ui';

import 'package:ab_smartly/json/unit.dart';
import 'package:flutter/foundation.dart';

import 'attribute.dart';
import 'exposure.dart';
import 'goal_achievement.dart';

class PublishEvent {
  bool hashed;
  List<Unit> units;
  int publishedAt;
  List<Exposure> exposures;
  List<GoalAchievement> goals;
  List<Attribute> attributes;

  PublishEvent({required this.hashed, required this.units, required this.publishedAt, required this.exposures, required this.goals, required this.attributes});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is PublishEvent &&
        o.hashed == hashed &&
        o.publishedAt == publishedAt &&
        listEquals(o.units, units) &&
        listEquals(o.exposures, exposures) &&
        listEquals(o.goals, goals) &&
        listEquals(o.attributes, attributes);
  }

  @override
  int get hashCode {
    int result = hashValues(hashed, publishedAt);
    result = 31 * result + units.hashCode;
    result = 31 * result + exposures.hashCode;
    result = 31 * result + goals.hashCode;
    result = 31 * result + attributes.hashCode;
    return result;
  }

  @override
  String toString() {
    return "PublishEvent{hashedUnits=$hashed, units=$units, publishedAt=$publishedAt, exposures=$exposures, goals=$goals, attributes=$attributes}";
  }
}