import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'experiment_varient.dart';
import 'experimet_application.dart';

class Experiment {
  int id;
  String name;
  String unitType;
  int iteration;
  int seedHi;
  int seedLo;
  List<double> split;
  int trafficSeedHi;
  int trafficSeedLo;
  List<double> trafficSplit;
  int fullOnVariant;
  List<ExperimentApplication> applications;
  List<ExperimentVariant> variants;
  bool audienceStrict;
  String audience;

  Experiment({
    required this.id,
    required this.name,
    required this.unitType,
    required this.iteration,
    required this.seedHi,
    required this.seedLo,
    required this.split,
    required this.trafficSeedHi,
    required this.trafficSeedLo,
    required this.trafficSplit,
    required this.fullOnVariant,
    required this.applications,
    required this.variants,
    required this.audienceStrict,
    required this.audience,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Experiment &&
            id == other.id &&
            name == other.name &&
            unitType == other.unitType &&
            iteration == other.iteration &&
            seedHi == other.seedHi &&
            seedLo == other.seedLo &&
            trafficSeedHi == other.trafficSeedHi &&
            trafficSeedLo == other.trafficSeedLo &&
            fullOnVariant == other.fullOnVariant &&
            listEquals(split, other.split) &&
            listEquals(trafficSplit, other.trafficSplit) &&
            listEquals(applications, other.applications) &&
            listEquals(variants, other.variants) &&
            audienceStrict == other.audienceStrict &&
            audience == other.audience;
  }

  @override
  int get hashCode {
    int result = hashValues(id, name, unitType, iteration, seedHi, seedLo,
        trafficSeedHi, trafficSeedLo, fullOnVariant, audienceStrict, audience);
    result = 31 * result + split.hashCode;
    result = 31 * result + trafficSplit.hashCode;
    result = 31 * result + applications.hashCode;
    result = 31 * result + variants.hashCode;
    return result;
  }

  @override
  String toString() {
    return "ContextExperiment{id=$id, name='$name', unitType='$unitType', iteration=$iteration, seedHi=$seedHi, seedLo=$seedLo, split=$split, trafficSeedHi=$trafficSeedHi, trafficSeedLo=$trafficSeedLo, trafficSplit=$trafficSplit, fullOnVariant=$fullOnVariant, applications=$applications, variants=$variants, audienceStrict=$audienceStrict, audience='$audience'}";
  }
}
