import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fireStore;
import 'package:flutter/material.dart';
import 'package:quanly_thuchi/model/transaction.dart' as MyTransaction;
import 'package:quanly_thuchi/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:quanly_thuchi/model/transaction_section.dart';
import 'package:quanly_thuchi/model/index.dart';
import 'package:quanly_thuchi/model/category_model.dart';
import 'package:quanly_thuchi/model/user.dart';

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
    final String subUserName = prefs.getString(SUB_USER_NAME);
    reExData.setSubUserId = subUserName;
    await insertNewReEXData(reExData, prefs);
    return;
  }

  Future<void> createReExDataWithExistUser(
      MyTransaction.Transaction reExData) async {
    final prefs = await SharedPreferences.getInstance();
    await insertNewReEXData(reExData, prefs);
    return;
  }

  insertNewReEXData(
      MyTransaction.Transaction reExData, SharedPreferences prefs) async {
    final String userId = prefs.getString(USER_NAME) ?? "temp";

    //lay id thoi gian thu chi
    List<String> timeSeprate = reExData.time.split(" ");
    String time = timeSeprate[0];
    int hour = int.parse(time.split(":")[0]);
    String minute = time.split(":")[1];
    String timeType = timeSeprate.length > 1 ? timeSeprate[1] : "";
    //format lai cho hop le
    if (timeType == "PM") {
      hour += 12;
    }
    String strHour = hour.toString();

    if (strHour.length == 1) {
      strHour = "0" + hour.toString();
    }
    if (minute.length == 1) {
      minute += "0" + minute;
    }
    String dateTime = reExData.date + " " + strHour + ":" + minute + ":00";

    DateTime dateCreate = DateTime.parse(dateTime);

    var rng = new Random();

    reExData.setId = dateCreate.millisecondsSinceEpoch + rng.nextInt(10000);
    //
    await Firestore.instance
        .collection(userId)
        .document("data")
        .collection("transaction")
        .document(reExData.id.toString())
        .setData(reExData.toMap());
  }

  Stream<QuerySnapshot> getAllData({String date, int offset, int limit}) {
    return SharedPreferences.getInstance().then((prefs) {
      final String userId = prefs.getString(USER_NAME) ?? "temp";
      final String subUserName = prefs.getString(SUB_USER_NAME);
      if (subUserName != SUB_USER_NAME_EMPTY)
        return Firestore.instance
            .collection(userId)
            .document("data")
            .collection("transaction")
            .where("date", isEqualTo: date)
            .where('sub_user', isEqualTo: subUserName)
            .getDocuments();
      else
        return Firestore.instance
            .collection(userId)
            .document("data")
            .collection("transaction")
            .where("date", isEqualTo: date)
            .getDocuments();
    }).asStream();
  }

  Future<List<MyTransaction.Transaction>> getReExDataList(
      {String date, int offset, int limit}) async {
    final prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString(USER_NAME) ?? "temp";
    final String subUserName = prefs.getString(SUB_USER_NAME);
    List<MyTransaction.Transaction> listData = new List();
    QuerySnapshot querySnapshot;
    if (subUserName != SUB_USER_NAME_EMPTY)
      querySnapshot = await Firestore.instance
          .collection(userId)
          .document("data")
          .collection("transaction")
          .where('sub_user', isEqualTo: subUserName)
          .where("date", isEqualTo: date)
          .getDocuments();
    else
      querySnapshot = await Firestore.instance
          .collection(userId)
          .document("data")
          .collection("transaction")
          .where("date", isEqualTo: date)
          .getDocuments();
    var list = querySnapshot.documents;
    for (final e in list) {
      listData.add(new MyTransaction.Transaction.fromMap(e.data));
    }
    return listData;
  }

  Future<dynamic> updateReExData(MyTransaction.Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString(USER_NAME) ?? "temp";
    return Firestore.instance
        .collection(userId)
        .document("data")
        .collection("transaction")
        .document(transaction.id.toString())
        .updateData(transaction.toMap());
  }

  Future<void> deleteReExData(int id) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String userId = prefs.getString(USER_NAME) ?? "temp";

    await Firestore.instance
        .collection(userId)
        .document("data")
        .collection("transaction")
        .document(id.toString())
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

    QuerySnapshot snapshot = await Firestore.instance
        .collection("sub_user")
        .where('user', isEqualTo: userName)
        .getDocuments();
    if (snapshot.documents.length == 0) {
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
    DocumentSnapshot snapshot = await Firestore.instance
        .collection("sub_user")
        .document(userName)
        .get();
    Map<String, dynamic> map = snapshot.data;
    final prefs = await SharedPreferences.getInstance();
    String user = map['user'];
    String pass = map['pass'];
    String parentName = map['parent_name'];
    if (userName == user && passWord == pass && parentName != null) {
      // set value
      prefs.setString(SUB_USER_NAME, user);
      prefs.setString(USER_NAME, parentName);
      return true;
    }
    return false;
  }

  Future<bool> deleteUser(String userName) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    QuerySnapshot snapshot = await Firestore.instance
        .collection("sub_user")
        .where('user', isEqualTo: userName)
        .getDocuments();
    if (snapshot.documents.length != 0) {
      await Firestore.instance
          .collection("sub_user")
          .document(userName)
          .delete();
      return true;
    }
    return false;
  }

  Future<List<User>> getAllUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString(USER_ID) ?? "temp";
    List<User> listData = new List();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("sub_user")
        .where("parent_id", isEqualTo: userId)
        .getDocuments();
    var list = querySnapshot.documents;
    for (final e in list) {
      listData.add(new User.fromMap(e.data));
    }
    return listData;
  }

  Future<bool> updateUser(User user) async {
    await Firestore.instance
        .collection("sub_user")
        .document(user.user)
        .updateData(user.toMap());
    return true;
  }

//
//  Future<List<DocumentSnapshot>> getTransactionFromDateToDate(
//      DateTime dateFrom, DateTime dateTo) async {
//    List<DocumentSnapshot> list = new List();
//    DateTime dateTime = dateFrom;
//    final prefs = await SharedPreferences.getInstance();
//    // set value
//    String subUser = prefs.getString(SUB_USER_NAME);
//    String user = prefs.getString(USER_NAME);
//    do {
//      QuerySnapshot querySnapshot = await Firestore.instance
//          .collection(user)
//          .document("data")
//          .collection(new DateFormat('yyyy-MM-dd').format(
//              new DateTime(dateTime.year, dateTime.month, dateTime.day)))
//          .where('sub_user', isEqualTo: subUser)
//          .getDocuments();
//      if (subUser == SUB_USER_NAME_EMPTY)
//        querySnapshot = await Firestore.instance
//            .collection(user)
//            .document("data")
//            .collection(new DateFormat('yyyy-MM-dd').format(
//                new DateTime(dateTime.year, dateTime.month, dateTime.day)))
//            .getDocuments();
//      for (final e in querySnapshot.documents) list.add(e);
//      dateTime = dateTime.add(new Duration(days: 1));
//    } while (!dateTime.isAfter(dateTo));
//    return list;
//  }

  Future<List<MyTransaction.Transaction>> getTransactionFromDateToDate(
      DateTime from, DateTime to) async {
    DateTime dateFrom = new DateTime(from.year, from.month, from.day, 0, 0, 0);
    DateTime dateTo = new DateTime(to.year, to.month, to.day, 0, 0, 0);
    dateTo = dateTo.add(new Duration(days: 1));
    List<MyTransaction.Transaction> list = new List();
    final prefs = await SharedPreferences.getInstance();
    // set value
    String subUser = prefs.getString(SUB_USER_NAME);
    String user = prefs.getString(USER_NAME);
    //ly do: query > 3 dieu kien bi loi => phai choi chieu
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(user)
        .document("data")
        .collection("transaction")
        .where('id', isGreaterThan: dateFrom.millisecondsSinceEpoch)
        .where('id', isLessThan: dateTo.millisecondsSinceEpoch)
        .getDocuments();
    //tai khoan con
    if (subUser != SUB_USER_NAME_EMPTY) {
      for (final e in querySnapshot.documents) {
        if (e["sub_user"] != subUser) {
          continue;
        }
        list.add(MyTransaction.Transaction.fromMap(e.data));
      }
    } else {
      //tai khoan cha
      for (final e in querySnapshot.documents) {
        list.add(MyTransaction.Transaction.fromMap(e.data));
      }
    }
    return list;
  }

  //category
  Future<bool> addCate(String category) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String userName = prefs.getString(USER_NAME) ?? "temp";
    int currentMiliSecond = DateTime.now().millisecondsSinceEpoch;
    CategoryModel categoryModel =
        new CategoryModel(currentMiliSecond, category);

    QuerySnapshot snapshot = await Firestore.instance
        .collection(userName)
        .document("category")
        .collection("data")
        .where('name', isEqualTo: category)
        .getDocuments();
    if (snapshot.documents.length > 0) {
      return false; //da ton tai
    }
    await Firestore.instance
        .collection(userName)
        .document("category")
        .collection("data")
        .document(categoryModel.id.toString())
        .setData(categoryModel.toMap());
    return true;
  }

  Future<List<CategoryModel>> getAllCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString(USER_NAME) ?? "temp";
    List<CategoryModel> listData = new List();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(userId)
        .document("category")
        .collection("data")
        .getDocuments();
    var list = querySnapshot.documents;
    for (final e in list) {
      listData.add(new CategoryModel.fromMap(e.data));
    }
    return listData;
  }

  Future<void> deleteCate(int id) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String userId = prefs.getString(USER_NAME) ?? "temp";

    await Firestore.instance
        .collection(userId)
        .document("category")
        .collection("data")
        .document(id.toString())
        .delete();
    return;
  }

  Future<dynamic> updateCategory(CategoryModel cate, String oldCateName) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String userId = prefs.getString(USER_NAME) ?? "temp";
    await Firestore.instance
        .collection(userId)
        .document("category")
        .collection("data")
        .document(cate.id.toString())
        .updateData(cate.toMap());

    var map = new Map<String, dynamic>();
    map["cate_name"] = cate.name;

    List<MyTransaction.Transaction> itemUpdate = await getReExDataList();
    itemUpdate.forEach((transaction) async {
      if (transaction.cateName == oldCateName) {
        transaction.setCateName = cate.name;
        await Firestore.instance
            .collection(userId)
            .document("data")
            .collection("transaction")
            .document(transaction.id.toString())
            .updateData(transaction.toMap());
      }
    });

//    querySnapshot.documents.forEach((e) {
//        e.data.update("cate_name", cate.name);
//      });
  }
}
