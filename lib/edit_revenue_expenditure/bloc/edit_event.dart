import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:quanly_thuchi/model/transaction.dart';

abstract class EditEvent extends Equatable{
}

class InsertData extends EditEvent{
  final Transaction reExData;
  InsertData({@required this.reExData});
}

class EditData extends EditEvent{

}

class Delete extends EditEvent{
  String date;
  String id;

  Delete({this.date, this.id});

}

class Update extends EditEvent{
  final Transaction reExData;
  Update({@required this.reExData});
}

class NoInternet extends EditEvent{
  NoInternet();
}

class CateChange extends EditEvent{

}