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