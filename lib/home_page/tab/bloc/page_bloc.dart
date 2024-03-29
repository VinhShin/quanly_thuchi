import 'package:bloc/bloc.dart';
import 'package:thuchi/home_page/tab/bloc/page_event.dart';
import 'package:thuchi/home_page/tab/bloc/page_state.dart';
import 'package:thuchi/repository/firestorage_repository.dart';
import 'package:thuchi/model/index.dart';
import 'package:thuchi/constant.dart';
import 'package:thuchi/model/transaction.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  FireStorageRepository _fireStorageRepository;
  List<TransactionSection> _listTemp;

  PageBloc() {
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
  PageState get initialState => PageLoadedData();

  @override
  Stream<PageState> mapEventToState(PageEvent event) async* {
    // TODO: implement mapEventToState
    if (event is PageLoadData) {
      yield new PageLoadingData(time: event.date);

      List<Transaction> listData = await _fireStorageRepository.getReExDataList(
          date: event.date, offset: 0, limit: 0);
      TransactionSection section = getTransactionSection(listData, event.date);
      _listTemp.add(section);
      yield PageLoadedData(section: section);
    } else if (event is OptionLoadData) {
      yield PageLoadingOption();
      List<Transaction> listData = await _fireStorageRepository
          .getTransactionFromDateToDate(event.fromDate, event.toDate);
      TransactionSection section = getTransactionSection(listData, "");
      _listTemp.add(section);
      yield PageLoadOption(section);
    } else if (event is OptionStart) {
      yield PageInitOption();
    }
  }

  TransactionSection getTransactionSection(
      List<Transaction> listData, String date) {
    int revenue = 0;
    int expendTure = 0;
    for (int i = 0; i < listData.length; i++) {
      if (listData[i].type == REVENUE_TYPE) {
        revenue += listData[i].money;
      } else {
        expendTure += listData[i].money;
      }
    }
    TransactionSection section = new TransactionSection(
        time: date,
        transactionHeader: new TransactionHeader(
            revenue: revenue,
            expendture: expendTure,
            total: revenue + expendTure),
        transactions: listData);

    for (int i = _listTemp.length - 1; i > 0; i--) {
      if (_listTemp[i].time == section.time) {
        _listTemp.removeAt(i);
        break;
      }
    }

    return section;
  }
}
