import 'dart:typed_data';

import '../buffers.dart';
import 'md5.dart';

abstract class Hashing {

  static ThreadLocal<Uint8List> threadBuffer = new ThreadLocal<Uint8List>() {
    @Override
    public byte[] initialValue() {
      return new byte[512];
    }
  };

  static Uint8List hashUnit(String unit) {
    final int n = unit.length;
    final int bufferLen = n << 1;

    Uint8List buffer = threadBuffer.get();
    if (buffer.length < bufferLen) {
      final int bit = 32 - Integer.numberOfLeadingZeros(bufferLen - 1);
      buffer = new byte[1 << bit];
      threadBuffer.set(buffer);
    }

    final int encoded = Buffers.encodeUTF8(buffer, 0, unit);
    return MD5.digestBase64UrlNoPadding(buffer, 0, encoded);
  }
}