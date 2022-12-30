import 'package:flutter/foundation.dart';

import 'json/experiment.dart';

class ContextData {
  List<Experiment> experiments = [];

  ContextData({List<Experiment>? experiments}) {
    this.experiments;
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final dynamic typedOther = other;
    return listEquals(experiments, typedOther.experiments);
  }

  @override
  int get hashCode => experiments.hashCode;

  @override
  String toString() {
    return 'ContextData{experiments: ${experiments.toString()}';
  }
}
