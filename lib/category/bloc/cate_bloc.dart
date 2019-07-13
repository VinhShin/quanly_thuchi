import 'package:bloc/bloc.dart';
import 'package:thuchi/repository/firestorage_repository.dart';
import 'package:thuchi/model/index.dart';
import 'package:thuchi/constant.dart';
import 'cate_event.dart';
import 'cate_state.dart';
import 'package:thuchi/model/category_model.dart';

class CateBloc extends Bloc<CateEvent, CateState> {
  FireStorageRepository _fireStorageRepository;
  List<TransactionSection> _listTemp;

  CateBloc() {
    _listTemp = new List();
    _fireStorageRepository = new FireStorageRepository();
  }

  TransactionSection getTemp(String date) {
    for (int i = _listTemp.length - 1; i > 0; i--) {
      if (_listTemp[i].time == date) {
        return _listTemp[i];
      }
    }
    return TransactionSection.init();
  }

  @override
  // TODO: implement initialState
  CateState get initialState => CateState();

  @override
  Stream<CateState> mapEventToState(CateEvent event) async* {
    // TODO: implement mapEventToState
    if (event is LoadCate) {
      yield CateLoading();
      List<CategoryModel> listCate =
          await _fireStorageRepository.getAllCategory();
      yield CateLoad(listCate);
    } else if (event is AddCate) {
      yield CateLoading();
      bool status = await _fireStorageRepository.addCate(event.cateName, event.type);
      List<CategoryModel> listCate =
          await _fireStorageRepository.getAllCategory();
      yield CateLoad(listCate);
    } else if (event is Update){
      yield CateLoading();
      await _fireStorageRepository.updateCategory(event.categoryModel, event.oldCateName);
      List<CategoryModel> listCate =
      await _fireStorageRepository.getAllCategory();
      yield CateLoad(listCate);
    } else if(event is Delete){
      yield CateLoading();
      await _fireStorageRepository.deleteCate(event.id);
      List<CategoryModel> listCate =
      await _fireStorageRepository.getAllCategory();
      yield CateLoad(listCate);
    } else if(event is CateChange){
      yield CateEdit(event.position);
    } else if(event is ChangeTextToAdd){
      yield CateNameAdd();
    } else if (event is EmptyEvent ){
      yield CateEmpty();
    }
  }
}
