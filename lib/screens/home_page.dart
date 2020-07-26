import 'package:apptitude/services/auth.dart';
import 'package:apptitude/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'link_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'web_search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

FirebaseUser user;
DBService dbService = DBService.instance;

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
            Icons.search,
            color: Colors.white,
          ),
          Text(
            " Search",
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

class _HomePageState extends State<HomePage> {
  dynamic data;
  Stream cards;
  List<CategoryTile> categories = [];
  TextEditingController newCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    AuthService _auth = AuthService();

    newCategoryDialog(BuildContext ctx) {
      return showDialog(
          context: ctx,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Add category', style: TextStyle(fontSize: 30)),
              content: TextField(
                autofocus: true,
                controller: newCategoryController,
                maxLines: null,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Add'),
                  onPressed: () async {
                    dbService.addCategory(user.uid, newCategoryController.text);
                    newCategoryController.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Links Organizer"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
                child: Tooltip(child: Icon(Icons.exit_to_app), message: "Sign Out"),
                onTap: () async => _auth.signOut()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newCategoryDialog(context),
        tooltip: 'Add Category',
        child: Icon(Icons.add, size: 40),
      ),
      body: CategoryStream(),
    );
  }
}

class CategoryStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: dbService.getUserCategories(user.uid),
        builder: (context, snapshot) {
          List<CategoryTile> categoriesList = [];
          if (snapshot.hasData) {
            final categories = snapshot.data.documents;
            for (var category in categories) {
              String _name;
              List _links;
              _name = category.documentID;
              _links = category.data['Links'];
              CategoryTile instance = CategoryTile(title: _name);
              categoriesList.add(instance);
            }
            return ListView.builder(
              itemBuilder: (ctx, index) {
                String _categoryTitle = categoriesList[index].title;
                return Dismissible(
                  key: Key(_categoryTitle),
                  child: CategoryTile(title: _categoryTitle),
                  background: slideRightBackground(),
                  secondaryBackground: slideLeftBackground(),
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
                                    dbService.deleteCategory(user.uid, _categoryTitle);
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
                      return res;
                    } else {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => WebSearch(searchParam: _categoryTitle)));
                      return false;
                    }
                  },
                );
              },
              itemCount: categoriesList.length,
            );
          } else
            return CircularProgressIndicator();
        });
  }
}

class CategoryTile extends StatelessWidget {
  CategoryTile({this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LinkPage(),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.black,
          child: Center(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 50, color: Colors.white),
            ),
          )),
        ),
      ),
    );
  }
}
