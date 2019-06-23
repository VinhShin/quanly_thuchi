class UserState{

  bool loading;
  bool loaded;
  bool addSuccess;

  UserState({this.loading, this.loaded, this.addSuccess});

  factory UserState.Empty(){
    return UserState(loading: false, loaded: false, addSuccess: false);
  }

  factory UserState.Processing(){
    return UserState(loading:true, loaded: false,  addSuccess:false);
  }


  factory UserState.AddUser(){
     return UserState(loading:false, loaded: false,  addSuccess:false);
  }

  factory UserState.AddResult(bool success ){
    return UserState(loading:false, loaded: true, addSuccess:success);
  }

}

