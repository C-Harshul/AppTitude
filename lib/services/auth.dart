import 'package:firebase_auth/firebase_auth.dart';
import 'db_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DBService dbService = DBService.instance;

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  FirebaseUser _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? user : null;
  }

  Future registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
      userUpdateInfo.displayName = displayName;
      user.updateProfile(userUpdateInfo);
      DBService.instance.createUser(user.uid, displayName, email);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      //signs in user
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
