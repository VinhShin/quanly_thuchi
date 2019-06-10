import 'package:meta/meta.dart';


class EditState{
  bool success;

  EditState({@required this.success});

  factory EditState.Empty(){
    return EditState();
  }

  factory EditState.Success(){
    return EditState(success:true);
  }

  factory EditState.Failure(){
    return EditState(success:false);
  }
}

class EditCateState extends EditState{
  String category;
  EditCateState({@required this.category});
}