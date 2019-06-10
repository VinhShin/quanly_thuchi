import 'package:bloc/bloc.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_event.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_state.dart';
import 'package:quanly_thuchi/repository/firestorage_repository.dart';
import 'package:quanly_thuchi/model/re_ex_data.dart';

class PageBloc extends Bloc<PageEvent, PageState>{

  FireStorageRepository _fireStorageRepository;

  PageBloc(){
    _fireStorageRepository = new FireStorageRepository();
  }

  @override
  // TODO: implement initialState
  PageState get initialState => PageLoadedData();

  @override
  Stream<PageState> mapEventToState(PageEvent event) async*{
    // TODO: implement mapEventToState
    if(event is PageLoadData){
      List<ReExData> listData = await _fireStorageRepository.getReExDataList(date: event.date,offset:0,limit:0);
      yield new PageLoadedData(listData: listData);
    }
  }
}