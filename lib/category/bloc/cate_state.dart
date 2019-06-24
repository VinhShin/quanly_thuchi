import 'package:meta/meta.dart';

final int STEP_INIT = 1;
final int STEP_INSERT = STEP_INIT + 1;//2
final int STEP_DELETE = STEP_INSERT + 1;//3
final int STEP_UPDATE = STEP_DELETE + 1;//4
final int CONNECT_FAIL = STEP_UPDATE + 1;
final int STEP_LOADING = CONNECT_FAIL + 1;
final int STEP_LOAD_CATE = STEP_LOADING + 1;
class CateState{
  int currentStep = 0;
  bool status = false;
  CateState({@required this.currentStep, @required this.status});

  factory CateState.Empty(){
    return CateState(currentStep:STEP_INIT , status: false);
  }

  factory CateState.Insert(bool state){
    return CateState(currentStep: STEP_INSERT,status: state);
  }

  factory CateState.Update(bool state){
    return CateState(currentStep: STEP_UPDATE,status: state);
  }

  factory CateState.Delete(bool state){
    return CateState(currentStep: STEP_DELETE,status: state);
  }

  factory CateState.LoadCate(){
    return CateState(currentStep: STEP_LOAD_CATE);
  }

  factory CateState.Loading(){
    return CateState(currentStep: STEP_LOADING, status: true);
  }

  factory CateState.FAIL(){
    return CateState(currentStep: CONNECT_FAIL,status: true);
  }



}
