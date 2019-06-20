import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quanly_thuchi/model/transaction.dart' as MyTransaction;
import 'package:quanly_thuchi/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

final CollectionReference noteCollection =
    Firestore.instance.collection('shops12');

class FireStorageRepository {
  static final FireStorageRepository _instance =
      new FireStorageRepository.internal();

  factory FireStorageRepository() => _instance;

  FireStorageRepository.internal();

  Future<bool> addShop(String userId, String shopName) async {
    await Firestore.instance.collection(userId).document(shopName).setData({});
    return true;
  }

  Future<void> createReExData(MyTransaction.Transaction reExData) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String userId = prefs.getString(USER_NAME) ?? "temp";
    int currentMiliSecond = DateTime.now().millisecondsSinceEpoch;
    reExData.setId = currentMiliSecond.toString();
    await Firestore.instance
        .collection(userId)
        .document("data")
        .collection(reExData.date)
        .document(reExData.id)
        .setData(reExData.toMap());
    return;
  }

  Future<List<MyTransaction.Transaction>> getReExDataList(
      {String date, int offset, int limit}) async {
    final prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString(USER_NAME) ?? "temp";

    List<MyTransaction.Transaction> listData = new List();
    QuerySnapshot querySnapshot =  await Firestore.instance
        .collection(userId)
        .document("data")
        .collection(date)
        .getDocuments();
    var list = querySnapshot.documents;
    for (final e in list) {
      listData.add(new MyTransaction.Transaction.fromMap(e.data));
    }
    return listData;
  }

  Future<dynamic> updateReExData(MyTransaction.Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String userId = prefs.getString(USER_NAME) ?? "temp";
    return Firestore.instance
        .collection(userId)
        .document("data")
        .collection(transaction.date)
        .document(transaction.id)
        .updateData(transaction.toMap());
  }

  Future<void> deleteReExData(String date, String id) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String userId = prefs.getString(USER_NAME) ?? "temp";

    await Firestore.instance
        .collection(userId)
        .document("data")
        .collection(date)
        .document(id)
        .delete();
    return;
  }
//
//  Future<void> addUser(String userName, String password) async {
//    final prefs = await SharedPreferences.getInstance();
//// Try reading data from the counter key. If it does not exist, return 0.
//    final String userId = prefs.getString(USER_ID) ?? "temp";
//    String currentMiliSecond = DateTime.now().millisecondsSinceEpoch.toString();
//    var map = new Map<String, dynamic>();
//    map["user"] = userName;
//    map["pass"] = password;
//    await Firestore.instance
//        .collection(userId)
//        .document(currentMiliSecond)
//        .setData(map);
//    return;
//  }

  Future<bool> addUser(String userName, String password) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String user_id = prefs.getString(USER_ID) ?? "temp";
    final String user_name = prefs.getString(USER_NAME) ?? "temp";


    QuerySnapshot snapshot = await Firestore.instance.collection("sub_user").where('user', isEqualTo: userName)
        .getDocuments();
    if(snapshot.documents.length==0){
      var map = new Map<String, dynamic>();
      map["user"] = userName;
      map["pass"] = password;
      map["parent_id"] = user_id;
      map["parent_name"] = user_name;
      await Firestore.instance
          .collection("sub_user")
          .document(userName)
          .setData(map);
      return true;
    }
    return false;
  }
  Future<bool> getUser(String userName, String passWord) async {
    DocumentSnapshot snapshot = await Firestore.instance.collection("sub_user").document(userName).get();
    if(snapshot.data.containsValue(passWord) && snapshot.data.containsValue(userName))
      return true;
    return false;
  }
}
