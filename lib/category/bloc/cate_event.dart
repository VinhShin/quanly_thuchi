import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:quanly_thuchi/model/transaction.dart';

abstract class CateEvent extends Equatable{
}

class InsertData extends CateEvent{
  final Transaction reExData;
  InsertData({@required this.reExData});
}

class EditData extends CateEvent{

}

class Delete extends CateEvent{
  String date;
  String id;

  Delete({this.date, this.id});

}

class Update extends CateEvent{
  final Transaction reExData;
  Update({@required this.reExData});
}

class LoadCate extends CateEvent{
  LoadCate();
}

class NoInternet extends CateEvent{
  NoInternet();
}

class CateChange extends CateEvent{

}