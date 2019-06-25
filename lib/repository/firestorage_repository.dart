import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quanly_thuchi/model/transaction.dart' as MyTransaction;
import 'package:quanly_thuchi/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:quanly_thuchi/model/transaction_section.dart';
import 'package:quanly_thuchi/model/index.dart';
import 'package:quanly_thuchi/model/category_model.dart';

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
    final String subUserName = prefs.getString(SUB_USER_NAME);
    reExData.setSubUserId = subUserName;
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



  Stream<QuerySnapshot> getAllData(
      {String date, int offset, int limit}) {
    return SharedPreferences.getInstance().then((prefs){
      final String userId = prefs.getString(USER_NAME) ?? "temp";
      final String subUserName = prefs.getString(SUB_USER_NAME);
      if(subUserName!= SUB_USER_NAME_EMPTY)
        return Firestore.instance
            .collection(userId)
            .document("data")
            .collection(date)
            .where('sub_user', isEqualTo: subUserName).getDocuments();
      else
        return Firestore.instance
            .collection(userId)
            .document("data")
            .collection(date).getDocuments();
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
          .collection(date)
          .where('sub_user', isEqualTo: subUserName)
          .getDocuments();
    else
      querySnapshot = await Firestore.instance
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


//  Future<TransactionSection> getReExDataList(
//      {String date, int offset, int limit}) {
//    return SharedPreferences.getInstance().then((prefs){
//      final String userId = prefs.getString(USER_NAME) ?? "temp";
//      final String subUserName = prefs.getString(SUB_USER_NAME);
//      List<MyTransaction.Transaction> listData = new List();
//      Future<QuerySnapshot> querySnapshot;
//      if(subUserName!='sub_user_name_is_empty')
//        querySnapshot = Firestore.instance
//            .collection(userId)
//            .document("data")
//            .collection(date)
//            .where('sub_user', isEqualTo: subUserName)
//            .getDocuments();
//      else
//        querySnapshot =  Firestore.instance
//            .collection(userId)
//            .document("data")
//            .collection(date)
//            .getDocuments();
//
//      querySnapshot.then((querySnapshot){
//        var list = querySnapshot.documents;
//        for (final e in list) {
//          listData.add(new MyTransaction.Transaction.fromMap(e.data));
//        }
//        int revenue = 0;
//        int expendTure = 0;
//        for(int i = 0 ; i < listData.length; i++){
//          if(listData[i].type == REVENUE_TYPE){
//            revenue += listData[i].money;
//          } else{
//            expendTure += listData[i].money;
//          }
//        }
//        TransactionSection section = new TransactionSection(
//            transactionHeader: new TransactionHeader(revenue: revenue, expendture: expendTure, total: revenue + expendTure),
//            transactions: listData
//        );
//
//        return section;
//      });
//    });
//
//
//  }


  Future<dynamic> updateReExData(MyTransaction.Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String userId = prefs.getString(USER_NAME) ?? "temp";
    final String subUserName = prefs.getString(SUB_USER_NAME);
    transaction.setSubUserId = subUserName;
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

      //List<DocumentSnapshot> list =
      //await getDataFromDateTo(DateTime.now(), DateTime.utc(2019, 12, 30));
      //list.toString();
      return true;
    }
    return false;
  }
  Future<List<DocumentSnapshot>> getDataFromDateTo(
      DateTime dateFrom, DateTime dateTo) async {

    List<DocumentSnapshot> list = new List();
    DateTime dateTime = dateFrom;
    final prefs = await SharedPreferences.getInstance();
    // set value
    String subUser = prefs.getString(SUB_USER_NAME);
    String user = prefs.getString(USER_NAME);
    do {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(user)
          .document("data")
          .collection(new DateFormat('yyyy-MM-dd').format(new DateTime(dateTime.year,dateTime.month,dateTime.day)))
          .where('sub_user', isEqualTo: subUser)
          .getDocuments();
      if (subUser == SUB_USER_NAME_EMPTY)
        querySnapshot = await Firestore.instance
            .collection(user)
            .document("data")
            .collection(new DateFormat('yyyy-MM-dd').format(new DateTime(dateTime.year,dateTime.month,dateTime.day)))
            .getDocuments();
      for (final e in querySnapshot.documents)
        list.add(e);
      dateTime = dateTime.add(new Duration(days: 1));
    } while (!dateTime.isAfter(dateTo));
  }

  //category
  Future<void> addCate(String category) async {

    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String userName = prefs.getString(USER_NAME) ?? "temp";
    int currentMiliSecond = DateTime.now().millisecondsSinceEpoch;
    CategoryModel categoryModel = new CategoryModel(currentMiliSecond, category);
    await Firestore.instance
        .collection(userName)
        .document("category")
        .collection("data")
        .document(categoryModel.id.toString())
        .setData(categoryModel.toMap());
    return;
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

  Future<dynamic> updateCategory(CategoryModel cate) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String userId = prefs.getString(USER_NAME) ?? "temp";
    return Firestore.instance
        .collection(userId)
        .document("category")
        .collection("data")
        .document(cate.id.toString())
        .updateData(cate.toMap());
  }

}
