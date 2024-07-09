import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_annotation/shared_preferences_annotation.dart';

part 'main.g.dart';

@SharedPrefData(entries: [
  SharedPrefEntry<String>(key: 'title', defaultValue: 'Hello, World!'),
  SharedPrefEntry<bool>(key: 'darkMode', defaultValue: false),
  SharedPrefEntry<int>(key: 'numberOfVisits', defaultValue: 0),
  SharedPrefEntry<List<String>>(key: 'history', defaultValue: ['0', '1']),
  SharedPrefEntry<DateTime>(key: 'lastVisit'),
  SharedPrefEntry<ThemeMode>(key: 'themeMode', defaultValue: ThemeMode.system),
  // SharedPrefEntry<MyModel>(key: 'myModel'),
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
    return MaterialApp(
      home: Home(prefs),
    );
  }
}

class Home extends StatefulWidget {
  const Home(this.prefs, {super.key});

  final SharedPreferences prefs;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    widget.prefs.lastVisit.setValue(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.prefs.entries.length,
        itemBuilder: (context, index) {
          final entry = widget.prefs.entries.elementAt(index);
          return ListTile(
            title: Text(entry.key),
            subtitle: Text(entry.value.toString()),
          );
        },
      ),
    );
  }
}
