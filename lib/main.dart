import 'package:apptitude/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamProvider<FirebaseUser>.value(
        value: AuthService().user,
        builder: (context, child) {
          return Wrapper();
        },
      ),
    );
  }
}
