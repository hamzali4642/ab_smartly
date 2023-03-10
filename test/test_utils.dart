import 'dart:io';

import 'package:ab_smartly/context_data_deserializer.dart';
import 'package:ab_smartly/context_data_deserializer.mocks.dart';
import 'package:flutter/services.dart';

Future<List<int>> getResourceBytes(String resourceName) async{

  String path = "resources/$resourceName";

  ByteData byteData = await rootBundle.load(path);
  Uint8List bytes = byteData.buffer.asUint8List();
  return bytes;
}
