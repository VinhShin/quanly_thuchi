import 'package:quanly_thuchi/model/user.dart';
class UserEvent{

}

class UserEventRegister extends UserEvent{
  String userName;
  String userPass;

  UserEventRegister({this.userName, this.userPass});
}

class UserEventDelete extends UserEvent{
  String userName;

  UserEventDelete({this.userName});
}

class UserUpdateEvent extends UserEvent{
  User userUpdate;
  UserUpdateEvent({this.userUpdate});
}

class GetAllUser extends UserEvent{

}
