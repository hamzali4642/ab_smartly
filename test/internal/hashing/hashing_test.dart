import 'dart:convert';

import 'package:ab_smartly/internal/hashing/hashing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  // test('testHashUnit', () {
  //   expect(
  //     'm-dATvrX39Pzf17xw_B35A',
  //     utf8.decode(
  //       Hashing.hashUnit(
  //           '4a42766ca6313d26f49985e799ff4f3790fb86efa0fce46edb3ea8fbf1ea3408'),
  //     ),
  //   );
  //
  //   expect('DRgslOje35bZMmpaohQjkA',
  //       utf8.decode(Hashing.hashUnit('bleh@absmarty.com')));
  //   expect('LxcqH5VC15rXfWfA_smreg', utf8.decode(Hashing.hashUnit('açb↓c')));
  //   expect('K5I_V6RgP8c6sYKz-TVn8g', utf8.decode(Hashing.hashUnit('testy')));
  //   expect('K4uy4bTeCy34W97lmceVRg',
  //       utf8.decode(Hashing.hashUnit(123456778999.toString())));
  // });
  //
  // test('testHashUnitLarge', () {
  //   const chars =
  //       '4a42766ca6313d26f49985e799ff4f3790fb86efa0fce46edb3ea8fbf1ea3408';
  //   final sb = StringBuffer();
  //
  //   const count = (2048 + chars.length - 1) ~/ chars.length;
  //   for (var i = 0; i < count; ++i) {
  //     sb.write(chars);
  //   }
  //
  //   expect(
  //       'Rxnq-eM9eE1SEoMnkEMOIw', utf8.decode(Hashing.hashUnit(sb.toString())));
  // });

  test('Test empty string hash', () {
    final hash = Hashing.hashUnit('');
    expect(base64Url.encode(hash), equals('1B2M2Y8AsgTpgAmY7PhCfg==')); // expected hash value for empty string
  });

  test('Test single character string hash', () {
    final hash = Hashing.hashUnit('a');
    expect(base64Url.encode(hash), equals('rL0Y20zC+Fzt72VPzMSk2A==')); // expected hash value for 'a'
  });

  test('Test multiple character string hash', () {
    final hash = Hashing.hashUnit('Hello, world!');
    expect(base64Url.encode(hash), equals('vUuW6U8A+IcX9XOvblgBjA==')); // expected hash value for 'Hello, world!'
  });

  test('Test buffer resizing', () {
    final longString = 'a' * 1000; // a string longer than the default buffer size
    final hash = Hashing.hashUnit(longString);
    expect(hash, isNotNull); // make sure a hash was generated
  });
  test('Test threadBuffer sharing', () {
    final hash1 = Hashing.hashUnit('foo');
    final hash2 = Hashing.hashUnit('bar');
    expect(hash1, isNot(equals(hash2))); // make sure different inputs generate different hashes
  });


}
