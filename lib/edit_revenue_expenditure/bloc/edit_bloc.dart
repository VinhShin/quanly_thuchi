import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'edit_event.dart';
import 'edit_state.dart';
import 'package:quanly_thuchi/repository/firestorage_repository.dart';
import 'package:quanly_thuchi/model/transaction.dart';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:quanly_thuchi/model/category_model.dart';

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

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (event is LoadCategory) {
        List<CategoryModel> listCate =
            await _fireStorageRepository.getAllCategory();
        yield EditAllCategory(listCate);
      } else if (event is InsertData) {
        yield EditState.Loading();
        yield* _insertData(event.reExData);
      } else if (event is Delete) {
        yield EditState.Loading();
        yield* _delete(event.id);
      } else if (event is Update) {
        yield EditState.Loading();
        //lý do: id được generate ra từ thời gian tạo thu chi
        // => khi update lại thời gian thu chi => id sẽ cần thay đổi
        //=> cách tốt nhất là xóa cái cũ + tạo lại mới cho đơn giản
        await _fireStorageRepository.deleteReExData(event.reExData.id);
        await _fireStorageRepository.createReExDataWithExistUser(event.reExData);
        yield EditState.Update(true);
      } else if (event is EditEventEmpty)
        yield EditState.Empty();
    } else {
      yield EditState.FAIL();
    }
  }

  Stream<EditState> _insertData(Transaction data) async* {
    try {
      await _fireStorageRepository.createReExData(data);
      yield EditState.Insert(true);
    } catch (_) {
      yield EditState.Insert(false);
    }
  }

  Stream<EditState> _delete(int id) async* {
    try {
      await _fireStorageRepository.deleteReExData(id);
      yield EditState.Delete(true);
    } catch (_) {
      yield EditState.Delete(false);
    }
  }

  Stream<EditState> _update(Transaction transaction) async* {
    try {
      await _fireStorageRepository.updateReExData(transaction);
      yield EditState.Update(true);
    } catch (_) {
      yield EditState.Update(false);
    }
  }
}
