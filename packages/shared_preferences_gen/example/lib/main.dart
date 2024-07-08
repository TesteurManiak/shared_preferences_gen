import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_annotation/shared_preferences_annotation.dart';

part 'main.g.dart';

@SharedPrefData(entries: [
  SharedPrefEntry<String>(key: 'title'),
  SharedPrefEntry<bool>(key: 'darkMode', defaultValue: false),
  SharedPrefEntry<int>(key: 'numberOfVisits', defaultValue: 0),
  SharedPrefEntry<List<String>>(key: 'history', defaultValue: []),
  DateTimeEntry(key: 'lastVisit'),
  MapEntry(key: 'myMap', defaultValue: {}),
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
      body: Center(
        child: Text('''
  SharedPreferences data:
  * title: ${widget.prefs.title}
  * darkMode: ${widget.prefs.darkMode}
  * numberOfVisits: ${widget.prefs.numberOfVisits}
  * history: ${widget.prefs.history}
  * lastVisit: ${widget.prefs.lastVisit}
  '''),
      ),
    );
  }
}
