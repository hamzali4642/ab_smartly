import 'dart:ui';

class Attribute {
  String name;
  Object value;
  int setAt;

  Attribute({required this.name, required this.value, required this.setAt});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Attribute &&
            setAt == other.setAt &&
            name == other.name &&
            value == other.value;
  }

  @override
  int get hashCode => hashValues(name, value, setAt);

  @override
  String toString() {
    return 'Attribute{name: $name, value: $value, setAt: $setAt}';
  }
}
