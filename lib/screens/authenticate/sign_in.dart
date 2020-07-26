import 'package:apptitude/services/auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;

  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _deviceHeight;
  var _deviceWidth;
  final AuthService _auth = AuthService();

  String _email = '';
  String _password = '';
  String error = '';
  String _name = '';
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
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(hintText: "Email", hintStyle: TextStyle(color: Colors.white)),
                            validator: (val) => val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() {
                                _email = val;
                              });
                            },
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(hintText: "Password", hintStyle: TextStyle(color: Colors.white)),
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
                                child: Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 25)),
                                color: Colors.green,
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    print('valid');
                                    var result = await _auth.signInWithEmailAndPassword(_email, _password);
                                    print(result);
                                    if (result == null)
                                      setState(() {
                                        error = 'Could not sign in';
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
                                child: Text("Register", style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  widget.toggleView();
                                }),
                          ),
                          SizedBox(height: 20),
                          Text(error),
                        ],
                      ),
                    ),
                  )),
            ),
    );
  }
}
