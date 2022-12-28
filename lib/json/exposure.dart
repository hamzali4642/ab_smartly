import 'dart:ui';

class Exposure {
  int id;
  String name;
  String unit;
  int variant;
  int exposedAt;
  bool assigned;
  bool eligible;
  bool overridden;
  bool fullOn;
  bool custom;
  bool audienceMismatch;

  Exposure({required this.id, required this.name, required this.unit, required this.variant, required this.exposedAt, required this.assigned, required this.eligible, required this.overridden, required this.fullOn, required this.custom, required this.audienceMismatch});

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is Exposure &&
        id == other.id &&
        variant == other.variant &&
        exposedAt == other.exposedAt &&
        assigned == other.assigned &&
        eligible == other.eligible &&
        overridden == other.overridden &&
        fullOn == other.fullOn &&
        custom == other.custom &&
        audienceMismatch == other.audienceMismatch &&
        name == other.name &&
        unit == other.unit;
  }

  @override
  int get hashCode => hashValues(id, name, unit, variant, exposedAt, assigned, eligible, overridden, fullOn, custom, audienceMismatch);

  @override
  String toString() {
    return 'Exposure{id: $id, name: $name, unit: $unit, variant: $variant, exposedAt: $exposedAt, assigned: $assigned, eligible: $eligible, overridden: $overridden, fullOn: $fullOn, custom: $custom, audienceMismatch: $audienceMismatch}';
  }
}