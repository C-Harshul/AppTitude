import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  Firestore _db;
  static DBService instance = DBService();
  String _usersCollection = "Users";
  String _categoriesCollection = 'Categories';
  String _flutterDocument = 'Flutter';
  String _defaultLink = "https://medium.com/@blog.padmal/flutter-dismissible-widget-swipe-both-ways-a696a1edb67b";
  String _defaultLinkName = "Flutter Dismissible";

  DBService() {
    _db = Firestore.instance;
  }

  Future createUser(String _uid, String _name, String _email) async {
    try {
      await _db
          .collection(_usersCollection)
          .document(_uid)
          .collection(_categoriesCollection)
          .document(_flutterDocument)
          .setData({
        "Links": [
          {"link": _defaultLink, "name": _defaultLinkName}
        ]
      });
      return await _db.collection(_usersCollection).document(_uid).setData({
        "name": _name,
        "email": _email,
      });
    } catch (e) {
      print(e);
    }
  }

  Future addCategory(String _userID, String _categoryName) async {
    var _ref = _db.collection(_usersCollection).document(_userID).collection(_categoriesCollection);
    return _ref.document(_categoryName).setData({"name" : "", "Links" : []});
  }

  Future deleteCategory(String _userID, String _categoryName) async {
    try {
      var _ref = _db.collection(_usersCollection).document(_userID).collection(_categoriesCollection);
      return _ref.document(_categoryName).delete();
    }catch(e){
      print(e);
    }
  }

  Stream getUserCategories(String _userID) {
    var _ref = _db.collection(_usersCollection).document(_userID).collection(_categoriesCollection);
    return _ref.snapshots();
  }
}
