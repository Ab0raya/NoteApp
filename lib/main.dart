import 'package:flutter/material.dart';
import 'AddNote.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home(),
      routes: {"add notes": (context) => AddNotes()},
    );
  }
}
