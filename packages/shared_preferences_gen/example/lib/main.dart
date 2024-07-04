import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_annotation/shared_preferences_annotation.dart';

part 'main.g.dart';

@SharedPrefData([
  SharedPrefEntry<String>(key: 'tmp'),
])
Future<void> main() async {
  final prefs = await SharedPreferences.getInstance();
  runApp(MainApp(prefs));
}

class MainApp extends StatelessWidget {
  const MainApp(this.prefs, {super.key});

  final SharedPreferences prefs;

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
