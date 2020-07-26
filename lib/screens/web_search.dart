import 'dart:async';
import 'package:apptitude/services/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebSearch extends StatefulWidget {
  WebSearch({this.searchParam, this.user, this.url});

  String searchParam;
  String currentUrl;
  String url;
  FirebaseUser user;

  @override
  _WebSearchState createState() => _WebSearchState();
}

class _WebSearchState extends State<WebSearch> {
  String currentUrl;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseUser user;
  DBService _dbService = DBService.instance;

  bool get isSearch => widget.searchParam != null;

  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          widget.currentUrl = url;
        });
      }
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  newLinkDialog(BuildContext ctx) {
    TextEditingController categoryController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController urlController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Add link', style: TextStyle(fontSize: 30)),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: Text("Category Name")),
                  TextFormField(
                      decoration: InputDecoration(hintText: "Flutter"),
                      autofocus: true,
                      controller: categoryController,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Enter a valid category';
                        } else {
                          return null;
                        }
                      }),
                  Align(alignment: Alignment.centerLeft, child: Text("Link URL")),
                  TextFormField(
                      decoration: InputDecoration(hintText: "www.google.com"),
                      controller: urlController,
                      maxLines: null,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Enter a valid url';
                        } else {
                          return null;
                        }
                      }),
                  SizedBox(height: 10),
                  Align(alignment: Alignment.centerLeft, child: Text("Link Name")),
                  TextFormField(
                      decoration: InputDecoration(hintText: "Google"),
                      controller: nameController,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Enter a valid name';
                        } else {
                          return null;
                        }
                      }),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _dbService.addLink(user.uid, categoryController.text, urlController.text, nameController.text);
                    urlController.clear();
                    nameController.clear();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    DBService dbService = DBService.instance;
    user = widget.user;

    return WebviewScaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0E21),
        actions: [
          isSearch == true
              ? IconButton(
            onPressed: () {
              //TODO: Save this link
              dbService.addLinkThroughWebview(user.uid, widget.searchParam, widget.currentUrl);
            },
            icon: Icon(Icons.add),
          ) : Container()
        ],
      ),
      key: scaffoldKey,
      url: isSearch == true
          ? 'https://www.google.com/search?q=${widget.searchParam}'
          : widget.url.startsWith('https://') ? widget.url : 'https://' + widget.url,
      //hidden: true,
    );
  }
}
