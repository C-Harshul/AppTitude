import 'package:apptitude/screens/web_search.dart';
import 'package:apptitude/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'slide_left.dart';

class LinkPage extends StatefulWidget {
  final String categoryName;
  FirebaseUser user;

  LinkPage({this.categoryName, this.user});

  @override
  _LinkPageState createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  DBService _dbService = DBService.instance;
  FirebaseUser user;

  newLinkDialog(BuildContext ctx) {
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
                  Align(alignment: Alignment.centerLeft, child: Text("Link URL")),
                  TextFormField(
                      decoration: InputDecoration(hintText: "www.google.com"),
                      autofocus: true,
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
                    _dbService.addLink(user.uid, widget.categoryName, urlController.text, nameController.text);
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

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.orange,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              "Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = widget.user;
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: StreamBuilder<DocumentSnapshot>(
          stream: _dbService.getUserLinks(user.uid, widget.categoryName),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              //print(snapshot.data.data);
              List _data = snapshot.data.data['Links'];
              return Container(
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(_data[index]["title"]),
                          direction: DismissDirection.endToStart,
                          background: slideLeftBackground(),
                          child: CategoryTile(title: _data[index]["name"], url: _data[index]['link'],),
                          confirmDismiss: (direction) async {
                            bool res;
                            if (direction == DismissDirection.endToStart) {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text("Are you sure you want to delete ?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            _dbService.deleteLink(widget.user.uid, widget.categoryName,
                                                _data[index]["link"], _data[index]["name"]);
                                            res = true;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              if (res == true) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Deleted successfully."),
                                  duration: Duration(seconds: 2),
                                ));
                              }
                              return false;
                            } else {
                              return false;
                            }
                          },
                        );
                      },
                      itemCount: _data.length,
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newLinkDialog(context);
        },
        tooltip: 'Add Category',
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  CategoryTile({this.title, String this.url});

  String title;
  String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, SlideLeftRoute(page: WebSearch(searchParam: null ,url: url)));
      },
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Card(
          color: Color(0xFF1D1E33),
          child: Center(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          )),
        ),
      ),
    );
  }
}
