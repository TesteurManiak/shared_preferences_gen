import 'package:flutter/material.dart';
import 'package:shared_preferences_annotation/shared_preferences_annotation.dart';

part 'main.g.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

@SharedPrefEntry<String>(key: 'tmp')
class SharedPrefTmp {}
