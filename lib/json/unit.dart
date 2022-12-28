import 'dart:ui';

class Unit {
  String type;
  String uid;

  Unit({required this.type, required this.uid});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Unit && type == other.type && uid == other.uid;
  }

  @override
  int get hashCode => hashValues(type, uid);

  @override
  String toString() {
    return 'Unit{type: $type, uid: $uid}';
  }
}
