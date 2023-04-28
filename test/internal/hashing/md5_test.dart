import 'dart:typed_data';

import 'package:ab_smartly/internal/hashing/md5.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main() {
  test('testDigestBase64UrlNoPadding', () {
    final testCases = [
      ["", "1B2M2Y8AsgTpgAmY7PhCfg"],
      [" ", "chXunH2dwinSkhpA6JnsXw"],
      ["t", "41jvpIn1gGLxDdcxa2Vkng"],
      ["te", "Vp73JkK-D63XEdakaNaO4Q"],
      ["tes", "KLZi2IO212_Zbk3cXpungA"],
      ["test", "CY9rzUYh03PK3k6DJie09g"],
      ["testy", "K5I_V6RgP8c6sYKz-TVn8g"],
      ["testy1", "8fT8xGipOhPkZ2DncKU-1A"],
      ["testy12", "YqRAtOz000gIu61ErEH18A"],
      ["testy123", "pfV2H07L6WvdqlY0zHuYIw"],
      ["special characters açb↓c", "4PIrO7lKtTxOcj2eMYlG7A"],
      ["The quick brown fox jumps over the lazy dog", "nhB9nTcrtoJr2B01QqQZ1g"],
      [
        "The quick brown fox jumps over the lazy dog and eats a pie",
        "iM-8ECRrLUQzixl436y96A"
      ],
      [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        "24m7XOq4f5wPzCqzbBicLA"
      ],
    ];

    for (var testCase in testCases) {
      final key = utf8.encode(testCase[0]);

      print(key);
      final actual = MD5.digestBase64UrlNoPadding(Uint8List.fromList(key));
      final expected = ascii.encode(testCase[1]);
      expect(expected, actual);

      final keyOffset = utf8.encode('123${testCase[0]}321');
      final actualOffset = MD5.digestBase64UrlNoPadding(
          Uint8List.fromList(keyOffset), offset: 3, len: keyOffset.length - 6);
      expect(expected, actualOffset);
    }
  });
}