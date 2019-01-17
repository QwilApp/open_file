import 'dart:async';

import 'package:flutter/services.dart';

class OpenFile {
  static const MethodChannel _channel = const MethodChannel('open_file');

  static Future<String> open(filePath, {allowToExport = false}) async {
    Map<String, dynamic> map = {
      "file_path": filePath,
      "allow_to_export": allowToExport
    };
    return await _channel.invokeMethod('open_file', map);
  }
}
