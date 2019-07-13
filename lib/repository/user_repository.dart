import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thuchi/repository/firestorage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thuchi/constant.dart';
import 'package:thuchi/model/category_model.dart';
import 'package:thuchi/model/transaction.dart' as my;

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  FireStorageRepository _fireStorageRepository;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(){
    _fireStorageRepository = new FireStorageRepository();
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseUser user = await _firebaseAuth.currentUser();
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setString(USER_ID, user.uid);
    prefs.setString(USER_NAME, user.email);
    prefs.setString(SUB_USER_NAME, SUB_USER_NAME_EMPTY);
    return;
  }

  Future<bool> signInWithSubUser(String uid, String upassword) async {
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setString(SUB_USER_NAME, SUB_USER_NAME_EMPTY);
    return await _fireStorageRepository.getUser(uid, upassword);
  }

  Future<void> signUp({String email, String password}) async {
    FirebaseUser user =  await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setString(USER_ID, user.uid);
    prefs.setString(USER_NAME, user.email);
    prefs.setString(SUB_USER_NAME, SUB_USER_NAME_EMPTY);
    return user;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SUB_USER_NAME, SUB_USER_NAME_EMPTY);
    prefs.setString(USER_NAME, USER_NAME_EMPTY);
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }

  Future<String> getId() async {
    return (await _firebaseAuth.currentUser()).uid;
  }
  Future<List<my.Transaction>> getDateFromTo(DateTime dateFrom, DateTime dateTo) async{
    return await _fireStorageRepository.getTransactionFromDateToDate(dateFrom, dateTo);
  }
  Future<List<CategoryModel>> getAllCategory() async{
    return await _fireStorageRepository.getAllCategory();
  }

  void resetPassword(String _userEmail) async{
    _firebaseAuth.sendPasswordResetEmail(email: _userEmail).then((value){

    });
  }
}
