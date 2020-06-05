import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  bool isLoading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  Map<String, dynamic> userData = Map();

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFailure}) {
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(email: userData["email"], password: password).then((user) async {
      firebaseUser = user;
      onSuccess();
      await _saveUserData(userData);
      isLoading = false;
    }).catchError((e) {
      onFailure();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  void recoverPass() {

  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }
}
