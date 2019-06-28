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
  UserState get initialState => UserAdd.Empty();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    // TODO: implement mapEventToState
    if(event is UserEventRegister){
      yield UserAdd.Processing();
      yield* inserNewUser(event.userName, event.userPass);
    } else if (event is UserEventDelete){
      yield UserAdd.Processing();
      yield* deleteUser(event.userName);
    }
  }

  Stream<UserState> inserNewUser(String user, String pass) async* {
    try{
      bool success = await _fireStorageRepository.addUser(user, pass);
      yield UserAdd.AddResult(success);
    }catch(_){
      yield UserAdd.AddResult(false);
    }
  }

  Stream<UserState> deleteUser(String user) async* {
    try{
      bool success = await _fireStorageRepository.deleteUser(user);
      yield UserDelete.DeleteResult(success);
    }catch(_){
      yield UserDelete.DeleteResult(false);
    }
  }




}