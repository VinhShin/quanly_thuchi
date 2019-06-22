import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'edit_event.dart';
import 'edit_state.dart';
import 'package:quanly_thuchi/repository/firestorage_repository.dart';
import 'package:quanly_thuchi/model/transaction.dart';
import 'dart:io';

class EditBloc extends Bloc<EditEvent, EditState> {

  FireStorageRepository _fireStorageRepository;

  EditBloc() {
    _fireStorageRepository = new FireStorageRepository();
  }

  @override
  // TODO: implement initialState
  EditState get initialState => EditState.Empty();

  @override
  Stream<EditState> mapEventToState(EditEvent event) async* {
    // TODO: implement mapEventToState
      try {
        yield EditState.Loading();
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if (event is InsertData) {
            yield* _insertData(event.reExData);
          }else if (event is Delete){
            yield* _delete(event.date, event.id);
          } else if(event is Update){
            yield* _update(event.reExData);
          }
        }
      } on SocketException catch (_) {
        yield EditState.FAIL();
      }

  }

  Stream<EditState> _insertData(Transaction data) async* {
    try{
      await _fireStorageRepository.createReExData(data);
      yield EditState.Insert(true);
    }catch(_){
      yield EditState.Insert(false);
    }
  }

  Stream<EditState> _delete(String data, String id) async* {
    try{
      await _fireStorageRepository.deleteReExData(data, id);
      yield EditState.Delete(true);
    }catch(_){
      yield EditState.Delete(false);
    }
  }
  
  Stream<EditState> _update(Transaction transaction) async* {
    try{
      await _fireStorageRepository.updateReExData(transaction);
      yield EditState.Update(true);
    }catch(_){
      yield EditState.Update(false);
    }
  }
}
