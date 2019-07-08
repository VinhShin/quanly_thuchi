import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './bloc.dart';
import 'package:quanly_thuchi/repository/user_repository.dart';
import 'package:quanly_thuchi/model/category_model.dart';
import 'package:quanly_thuchi/model/transaction.dart' as my;

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  // ignore: unused_field
  UserRepository _userRepository;

  ReportBloc() {
    _userRepository = new UserRepository();
  }
  @override
  ReportState get initialState => ReportState.Init();


  @override
  Stream<ReportState> mapEventToState(ReportEvent event,) async* {
    // TODO: Add Logic
    if (event is ReportPressed)
      yield* _mapReportPressedToState(
          datefrom: event.datefrom, dateto: event.dateto, type: event.type);
    if (event is ReportInit)
      yield* _reportInit();
    if (event is ReportReload)
      yield* _reportReload();
  }
  Stream<ReportState> _reportInit() async*{ yield ReportStart(); }
  Stream<ReportState> _reportReload() async*{ yield ReportReloaded(); }
  Stream<ReportState> _mapReportPressedToState(
      {DateTime datefrom, DateTime dateto, String type}) async* {
    yield Reporting();
    int sumRe = 0;
    int sumEx = 0;
    List<CategoryModel> listCate = new List();
    listCate = await _userRepository.getAllCategory();
    if(listCate == null || listCate.length == 0){
      listCate.add(CategoryModel(-1, "Rỗng"));
    }
    var mapEx = new Map<String,double>();
    var mapRe = new Map<String,double>();
    for(final e in listCate)
      {
        mapRe[e.name] = 0;
        mapEx[e.name] = 0;
      }
    // ignore: unused_local_variable
    List<my.Transaction> list = new List();
    List<my.Transaction> listRevenue = new List();
    List<my.Transaction> listExpendture = new List();

    if(list == null)
      yield ReportState.Failure();
    else{
      switch (type){
        case 'd':
          list = await _userRepository.getDateFromTo(datefrom, datefrom);
          break;
        case 'w':
          DateTime fistDayOfWeek = datefrom.add(new Duration(days: -datefrom.weekday));
          DateTime lastDayOfWeek = fistDayOfWeek.add(new Duration(days: 7));
          list = await _userRepository.getDateFromTo(fistDayOfWeek, lastDayOfWeek);
          break;
        case 'm':
          DateTime fistDayOfMonth = new DateTime(datefrom.year,datefrom.month,1);
          DateTime lastDayOfMonth = new DateTime(datefrom.year,datefrom.month+1,0);
          if(datefrom.month == 12)
           lastDayOfMonth = new DateTime(datefrom.year+1,1,0);
          list = await _userRepository.getDateFromTo(fistDayOfMonth, lastDayOfMonth);
          break;
        case 'y':
          DateTime fistDayOfYear = new DateTime(datefrom.year,1,1);
          DateTime lastDayOfYear = new DateTime(datefrom.year,12,31);
          list = await _userRepository.getDateFromTo(fistDayOfYear, lastDayOfYear);
          break;
        case 'd2d':
          list = await _userRepository.getDateFromTo(datefrom, dateto);
          break;
      }
      for(final e in list)
      {
        if(e.type == 1){
          sumEx += e.money;
          mapEx[e.cateId] += e.money;
          listExpendture.add(e);
        } else {
          sumRe += e.money;
          mapRe[e.cateId] += e.money;
          listRevenue.add(e);
        }
      }
      yield ReportState.Success();
    }
    yield ReportAll(sumRe,sumEx,mapEx,mapRe, type, listExpendture, listRevenue);
    }
}

