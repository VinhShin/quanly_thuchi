import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:quanly_thuchi/model/transaction.dart';
import 'package:quanly_thuchi/model/category_model.dart';
abstract class CateEvent extends Equatable {
}

class InsertData extends CateEvent {
  final Transaction reExData;

  InsertData({@required this.reExData});
}

class Delete extends CateEvent {
  int id;

  Delete({this.id});

}

class Update extends CateEvent {
  final CategoryModel categoryModel;

  Update({@required this.categoryModel});
}

class LoadCate extends CateEvent {
  LoadCate();
}

class AddCate extends CateEvent {
  String cateName;

  AddCate(this.cateName);
}

class NoInternet extends CateEvent {
  NoInternet();
}

class CateChange extends CateEvent {
  int position;
  CateChange(this.position);
}

class ChangeTextToAdd extends CateEvent{
}

class EmptyEvent extends CateEvent{}