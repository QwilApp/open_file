import 'package:flutter/material.dart';
import 'dart:async';

import 'package:open_file/open_file.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _openResult = 'Unknown';

  @override
  void initState() {
    super.initState();
    openFile("/storage/emulated/0/Download/2.jpg").then((_result) {
      setState(() {
        _openResult = _result;
      });
    });
  }

  Future<String> openFile(String filePath) async {
    return await OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(
            child: Text('open result: $_openResult\n'),
          ),
        ),
      ),
    );
  }
}
