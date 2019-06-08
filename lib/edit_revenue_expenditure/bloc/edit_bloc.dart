import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'edit_event.dart';
import 'edit_state.dart';
import 'package:quanly_thuchi/firestorage_repository.dart';
import 'package:quanly_thuchi/model/re_ex_data.dart';

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
    if (event is InsertData) {
      yield* _insertData(event.reExData);
    }
  }

  Stream<EditState> _insertData(ReExData data) async* {
    try{
      await _fireStorageRepository.createReExData(data);
      yield EditState.Success();
    }catch(_){
      yield EditState.Failure();
    }
  }
}
