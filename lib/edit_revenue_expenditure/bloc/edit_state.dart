import 'package:meta/meta.dart';

final int STEP_INIT = 1;
final int STEP_INSERT = STEP_INIT + 1;
final int STEP_DELETE = STEP_INSERT + 1;
final int STEP_UPDATE = STEP_DELETE + 1;
final int CONNECT_FAIL = STEP_UPDATE + 1;
final int STEP_LOADING = CONNECT_FAIL + 1;
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

  factory EditState.Loading(){
    return EditState(currentStep: STEP_LOADING, status: true);
  }

  factory EditState.FAIL(){
    return EditState(currentStep: CONNECT_FAIL,status: true);
  }



}



class EditCateState extends EditState{
  String category;
  EditCateState({@required this.category});
}