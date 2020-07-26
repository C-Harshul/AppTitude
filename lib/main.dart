import 'package:flutter/material.dart';
import 'Home.dart';
void main() {
  runApp(AppTitude());
}

class AppTitude extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: {
       '/Cats':(context) => Home(),

      },
    );
  }
}

