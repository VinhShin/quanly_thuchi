import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:thuchi/model/transaction.dart';
import 'package:thuchi/model/category_model.dart';
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
  final String oldCateName;
  Update({@required this.categoryModel, @required this.oldCateName});
}

class LoadCate extends CateEvent {
  LoadCate();
}

class AddCate extends CateEvent {
  String cateName;
  int type;

  AddCate(this.cateName, this.type);
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