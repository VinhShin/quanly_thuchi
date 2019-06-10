import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quanly_thuchi/model/re_ex_data.dart';
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

  Future<void> createReExData(ReExData reExData) async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    final String userId = prefs.getString(USER_ID) ?? "temp";
    final String userName = prefs.getString(USER_NAME) ?? "temp";
    var formatter = new DateFormat('yyyy-MM-dd');
    String today = formatter.format(DateTime.now());
    int currentMiliSecond = DateTime.now().millisecondsSinceEpoch;
    reExData.setId = currentMiliSecond.toString();
    await Firestore.instance
        .collection(userId)
        .document("data")
        .collection(today)
        .document()
        .setData(reExData.toMap());
    return;
  }

  Future<List<ReExData>> getReExDataList({String date, int offset, int limit}) async {
    final prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString(USER_ID) ?? "temp";
//    Stream<QuerySnapshot> snapshots = await Firestore.instance
//        .collection(userId)
//        .document("data")
//        .collection(today)
//        .snapshots();
//
//    if (offset != null) {
//      snapshots = snapshots.skip(offset);
//    }
//
//    if (limit != null) {
//      snapshots = snapshots.take(limit);
//    }
//    return snapshots.listen(onData);
    List<ReExData> listData = new List();
    QuerySnapshot querySnapshot = await await Firestore.instance
        .collection(userId)
        .document("data")
        .collection(date)
        .getDocuments();
    var list = querySnapshot.documents;
    for (final e in list) {
      listData.add(new ReExData.fromMap(e.data));
    }
    return listData;
  }

  Future<dynamic> updateReExData(ReExData note) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(noteCollection.document(note.id));

      await tx.update(ds.reference, note.toMap());
      return {'updated': true};
    };

    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  Future<dynamic> deleteReExData(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(noteCollection.document(id));

      await tx.delete(ds.reference);
      return {'deleted': true};
    };

    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((result) => result['deleted'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }
}
