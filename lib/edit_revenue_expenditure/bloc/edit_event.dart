import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:thuchi/model/transaction.dart';

abstract class EditEvent extends Equatable {}

class InsertData extends EditEvent {
  final Transaction reExData;

  InsertData({@required this.reExData});
}

class EditData extends EditEvent {}

class LoadCategory extends EditEvent {}

class Delete extends EditEvent {
  String date;
  int id;

  Delete({this.date, this.id});
}

class Update extends EditEvent {
  final Transaction reExData;

  Update({@required this.reExData});
}

class NoInternet extends EditEvent {
  NoInternet();
}

class CateChange extends EditEvent {}

class EditEventEmpty extends EditEvent{}