import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class EditEvent extends Equatable{

}

class InsertData extends EditEvent{

}

class EditData extends EditEvent{

}

class Delete extends EditEvent{

}