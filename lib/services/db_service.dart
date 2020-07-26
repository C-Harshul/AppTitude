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
    return _ref.document(_categoryName).setData({"Links": []});
  }

  Future deleteCategory(String _userID, String _categoryName) async {
    var _ref = _db.collection(_usersCollection).document(_userID).collection(_categoriesCollection);
    return _ref.document(_categoryName).delete();
  }

  Future addLink(String _userID, String _categoryName, String _link, String _linkName) async {
    var _ref = _db.collection(_usersCollection).document(_userID).collection(_categoriesCollection).document(
        _categoryName);
    var data = [{"link": _link, "name": _linkName}];
    return _ref.updateData({"Links" : FieldValue.arrayUnion(data)});
  }

  Future addLinkThroughWebview(String _userID, String _categoryName, String _link) async {
    String name = '';
    var _ref = _db.collection(_usersCollection).document(_userID).collection(_categoriesCollection).document(
        _categoryName);
    int f=0;
    for(int i = 0;i<_link.toString().length;++i){
      if(f==1 && _link[i] != '.')
        name = name + _link[i];
      if(_link[i] == '.'){
        f++;
        if(f==2)
          break;
      }
    }
    var data = [{"link": _link, "name": name}];
    return _ref.updateData({"Links" : FieldValue.arrayUnion(data)});
  }

//  Future updateLink(String _userID, String _categoryName, String _link, String _linkName) async {
//    var _ref = _db.collection(_usersCollection).document(_userID).collection(_categoriesCollection).document(
//        _categoryName);
//    var data = [{"link": _link, "name": _linkName}];
//    return _ref.updateData({"Links": data});
//  }

  Future deleteLink(String _userID, String _categoryName, String _link, String _linkName) async {
    var _ref = _db.collection(_usersCollection).document(_userID).collection(_categoriesCollection).document(
        _categoryName);
    var data = [{"link": _link, "name": _linkName}];
    return _ref.updateData({"Links" : FieldValue.arrayRemove(data)});
  }

  Stream getUserLinks(String _userID, String _categoryName) {
    var _ref = _db.collection(_usersCollection).document(_userID).collection(_categoriesCollection);
    return _ref.document(_categoryName).snapshots();
  }

  Stream getUserCategories(String _userID) {
    var _ref = _db.collection(_usersCollection).document(_userID).collection(_categoriesCollection);
    return _ref.snapshots();
  }
}
