import 'package:apptitude/services/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    AuthService _auth = AuthService();

    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("Sign out"),
          onPressed: () {
            _auth.signOut();
          },
        ),
      ),
    );
  }
}
