import 'package:bloc/bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import 'package:quanly_thuchi/repository/firestorage_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState>{


  FireStorageRepository _fireStorageRepository;

  UserBloc() {
    _fireStorageRepository = new FireStorageRepository();
  }

  @override
  // TODO: implement initialState
  UserState get initialState => UserState.Empty();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    // TODO: implement mapEventToState
    if(event is UserEventRegister){
      yield UserState.Processing();
      yield* inserNewUser(event.userName, event.userPass);
    }
  }

  Stream<UserState> inserNewUser(String user, String pass) async* {
    try{
      bool success = await _fireStorageRepository.addUser(user, pass);
      yield UserState.AddResult(success);
    }catch(_){
      yield UserState.AddResult(false);
    }
  }




}