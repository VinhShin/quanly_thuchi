import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:quanly_thuchi/model/re_ex_data.dart';

abstract class EditEvent extends Equatable{
}

class InsertData extends EditEvent{
  final ReExData reExData;
  InsertData({@required this.reExData});
}

class EditData extends EditEvent{

}

class Delete extends EditEvent{

}