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
    String today = new DateFormat.yMMMd().format(DateTime.now());
    int currentMiliSecond = DateTime.now().millisecondsSinceEpoch;
    final ReExData newReExData = new ReExData(reExData.type, reExData.money,
        reExData.dateTime, reExData.note, currentMiliSecond.toString());

//    String data = json.encode(newReExData.toMap());
    await Firestore.instance
        .collection(userId)
        .document("data")
        .collection(today)
        .document()
        .setData(newReExData.toMap());
    return;
//    CollectionReference reference =  Firestore.instance.collection(user_id);
//    final TransactionHandler createTransaction = (Transaction tx) async {
//      final DocumentSnapshot ds = await tx.get(reference.document("data").collection(today).document());
//
//      final Map<String, dynamic> data = newReExData.toMap();
//
//      await tx.set(ds.reference, data);
//      return data;
//    };
//
//    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
//      return ReExData.fromMap(mapData);
//    }).catchError((error) {
//      print('error: $error');
//      return null;
//    });
  }

  Stream<QuerySnapshot> getReExDataList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = noteCollection.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
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
