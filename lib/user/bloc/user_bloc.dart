import 'package:bloc/bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
class UserBloc extends Bloc<UserEvent, UserState>{

  @override
  // TODO: implement initialState
  UserState get initialState => UserState.Empty();
//
//  @override
//  Stream<UserState> mapEventToState(UserEvent event) async {
//    // TODO: implement mapEventToState
//    if(event is UserEventRegister){
//      yield
//    }
//  }

@override
  Stream<UserState> mapEventToState(UserEvent event) {
    // TODO: implement mapEventToState
    return null;
  }

}