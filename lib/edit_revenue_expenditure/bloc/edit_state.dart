import 'package:meta/meta.dart';

final int STEP_INIT = 1;
final int STEP_INSERT = 2;
final int STEP_DELETE = 3;
final int STEP_UPDATE = 4;

class EditState{
  int currentStep = 0;
  bool status = false;
  EditState({@required this.currentStep, @required this.status});

  factory EditState.Empty(){
    return EditState(currentStep:STEP_INIT , status: false);
  }

  factory EditState.Insert(bool state){
    return EditState(currentStep: STEP_INSERT,status: state);
  }

  factory EditState.Update(bool state){
    return EditState(currentStep: STEP_UPDATE,status: state);
  }

  factory EditState.Delete(bool state){
    return EditState(currentStep: STEP_DELETE,status: state);
  }

}



class EditCateState extends EditState{
  String category;
  EditCateState({@required this.category});
}