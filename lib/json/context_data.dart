import 'package:flutter/foundation.dart';

import 'experiment.dart';

class ContextData {
  List<Experiment> experiments;

  ContextData({this.experiments = const []});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is ContextData && listEquals(o.experiments, experiments);
  }

  @override
  int get hashCode {
    return experiments.hashCode;
  }

  @override
  String toString() {
    return "ContextData{experiments=$experiments}";
  }
}
