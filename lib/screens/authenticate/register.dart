import 'package:apptitude/services/auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;

  RegisterPage({this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _deviceHeight;
  var _deviceWidth;
  final AuthService _auth = AuthService();

  String _email = '';
  String _name = '';
  String _password = '';
  String error = '';
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(hintText: "Name"),
                          validator: (val) => val.isEmpty ? 'Enter a name' : null,
                          onChanged: (val) {
                            setState(() {
                              _name = val;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(hintText: "Email"),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Enter an email';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              _email = val;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(hintText: "Password"),
                          validator: (val) => val.length < 6 ? 'Password should be longer than 6 characters' : null,
                          onChanged: (val) {
                            _password = val;
                          },
                        ),
                        SizedBox(height: 70),
                        SizedBox(
                          width: _deviceWidth * 0.75,
                          height: _deviceHeight * 0.06,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              color: Colors.green,
                              child: Text(
                                "REGISTER",
                                style: TextStyle(color: Colors.white, fontSize: 25),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var result = await _auth.registerWithEmailAndPassword(_email, _password, _name);
                                  if (result == null)
                                    setState(() {
                                      error = 'Need valid email and password';
                                      isLoading = false;
                                    });
                                  else {
                                    setState(() {
                                      isLoading = false;
                                      error = '';
                                    });
                                  }
                                }
                              }),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: _deviceWidth * 0.75,
                          height: _deviceHeight * 0.06,
                          child: FlatButton(
                              color: Colors.transparent,
                              child: Text("Sign In"),
                              onPressed: () {
                                widget.toggleView();
                              }),
                        ),
                        SizedBox(height: 20),
                        Text(error),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
