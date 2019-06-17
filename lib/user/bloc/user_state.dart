class UserState{

  bool loading;
  bool addSuccess;

  UserState({this.loading, this.addSuccess});

  factory UserState.Empty(){
    return UserState(loading: false, addSuccess: false);
  }

  factory UserState.AddUser(){
     return UserState(loading:true, addSuccess:false);
  }

  factory UserState.AddResult(bool success ){
    return UserState(loading:false, addSuccess:success);
  }

}

