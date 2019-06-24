import 'package:bloc/bloc.dart';
import 'package:quanly_thuchi/repository/firestorage_repository.dart';
import 'package:quanly_thuchi/model/index.dart';
import 'package:quanly_thuchi/constant.dart';
import 'cate_event.dart';
import 'cate_state.dart';

class CateBloc extends Bloc<CateEvent, CateState> {
  FireStorageRepository _fireStorageRepository;
  List<TransactionSection> _listTemp;
  PageBloc() {
    _listTemp = new List();
    _fireStorageRepository = new FireStorageRepository();
  }

  TransactionSection getTemp(String date){
    for(int i = _listTemp.length - 1 ; i > 0; i--){
      if(_listTemp[i].time == date){
        return _listTemp[i];
      }
    }
    return TransactionSection.init();
  }

  @override
  // TODO: implement initialState
  CateState get initialState => CateState.Empty();

  @override
  Stream<CateState> mapEventToState(CateEvent event) async* {
    // TODO: implement mapEventToState
    if (event is LoadCate) {

    }
  }
}
