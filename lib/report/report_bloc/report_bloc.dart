import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './bloc.dart';
import 'package:quanly_thuchi/repository/user_repository.dart';
import 'package:quanly_thuchi/model/category_model.dart';

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
    int tongThu = 0;
    int tongChi = 0;
    List<CategoryModel> listCate = new List();
    listCate = await _userRepository.getAllCategory();
    var map = new Map<String,int>();
    for(final e in listCate)
      {
        map[e.name] = 0;
      }
    // ignore: unused_local_variable
    List<DocumentSnapshot> list = new List();
    if(list == null)
      yield ReportState.Failure();
    else{
      switch (type){
        case 'd':
          list = await _userRepository.getDateFromTo(datefrom, datefrom);
           for(final e in list)
             {
               if(e.data['type']==1)
                 tongChi += e.data['money'];
               else
                 tongThu += e.data['money'];
               map[e.data['cate_id']] += e.data['money'];
             }
          break;
        case 'w':
          DateTime fistDayOfWeek = datefrom.add(new Duration(days: -datefrom.weekday));
          DateTime lastDayOfWeek = fistDayOfWeek.add(new Duration(days: 7));
          list = await _userRepository.getDateFromTo(fistDayOfWeek, lastDayOfWeek);
          for(final e in list)
          {
            if(e.data['type']==1)
              tongChi += e.data['money'];
            else
              tongThu += e.data['money'];
            map[e.data['cate_id']] += e.data['money'];
          }
          break;
        case 'm':
          DateTime fistDayOfMonth = new DateTime(datefrom.year,datefrom.month,1);
          DateTime lastDayOfMonth = new DateTime(datefrom.year,datefrom.month+1,0);
          if(datefrom.month == 12)
           lastDayOfMonth = new DateTime(datefrom.year+1,1,0);
          list = await _userRepository.getDateFromTo(fistDayOfMonth, lastDayOfMonth);
          for(final e in list)
          {
            if(e.data['type']==1)
              tongChi += e.data['money'];
            else
              tongThu += e.data['money'];
            map[e.data['cate_id']] += e.data['money'];
          }
          break;
        case 'y':
          DateTime fistDayOfYear = new DateTime(datefrom.year,1,1);
          DateTime lastDayOfYear = new DateTime(datefrom.year,12,31);
          list = await _userRepository.getDateFromTo(fistDayOfYear, lastDayOfYear);
          for(final e in list)
          {
            if(e.data['type']==1)
              tongChi += e.data['money'];
            else
              tongThu += e.data['money'];
            map[e.data['cate_id']] += e.data['money'];
          }
          break;
      }

      yield ReportState.Success();
    }
    yield ReportAll(tongThu,tongChi,map);
    }
}

