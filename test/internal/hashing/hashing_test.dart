import 'package:ab_smartly/internal/hashing/hashing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main() {
  test('testHashUnit', () {
    expect(
        'H2jvj6o9YcAgNdhKqEbtWw',
        utf8.decode(Hashing.hashUnit(
            '4a42766ca6313d26f49985e799ff4f3790fb86efa0fce46edb3ea8fbf1ea3408')));
    expect(
        'DRgslOje35bZMmpaohQjkA',
        utf8.decode(Hashing.hashUnit('bleh@absmarty.com')));
    expect(
        'LxcqH5VC15rXfWfA_smreg', utf8.decode(Hashing.hashUnit('açb↓c')));
    expect(
        'K5I_V6RgP8c6sYKz-TVn8g', utf8.decode(Hashing.hashUnit('testy')));
    expect(
        'K4uy4bTeCy34W97lmceVRg',
        utf8.decode(Hashing.hashUnit(123456778999.toString())));
  });

  test('testHashUnitLarge', () {
    final chars = '4a42766ca6313d26f49985e799ff4f3790fb86efa0fce46edb3ea8fbf1ea3408';
    final sb = StringBuffer();

    final count = (2048 + chars.length - 1) ~/ chars.length;
    for (var i = 0; i < count; ++i) {
      sb.write(chars);
    }

    expect(
        'Rxnq-eM9eE1SEoMnkEMOIw', utf8.decode(Hashing.hashUnit(sb.toString())));
  });
}
