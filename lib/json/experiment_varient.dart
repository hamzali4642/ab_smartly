import 'dart:ui';

class ExperimentVariant {
  String name;
  String config;

  ExperimentVariant({required this.name, required this.config});

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is ExperimentVariant &&
        name == other.name &&
        config == other.config;
  }

  @override
  int get hashCode => hashValues(name, config);

  @override
  String toString() {
    return 'ExperimentVariant{name: $name, config: $config}';
  }
}



