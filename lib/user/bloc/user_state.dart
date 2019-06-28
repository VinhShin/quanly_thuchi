class UserState{
}

class UserAdd extends UserState{

  bool loading;
  bool loaded;
  bool addSuccess;

  UserAdd({this.loading, this.loaded, this.addSuccess});

  factory UserAdd.Empty(){
    return UserAdd(loading: false, loaded: false, addSuccess: false);
  }

  factory UserAdd.Processing(){
    return UserAdd(loading:true, loaded: false,  addSuccess:false);
  }


  factory UserAdd.AddUser(){
    return UserAdd(loading:false, loaded: false,  addSuccess:false);
  }

  factory UserAdd.AddResult(bool success ){
    return UserAdd(loading:false, loaded: true, addSuccess:success);
  }
}

class UserDelete extends UserState{
  bool loading;
  bool delete;
  bool deleteSuccess;

  UserDelete({this.loading, this.delete, this.deleteSuccess});

  factory UserDelete.Empty(){
    return UserDelete(loading: false, delete: false, deleteSuccess: false);
  }

  factory UserDelete.Processing(){
    return UserDelete(loading:true, delete: false,  deleteSuccess:false);
  }


  factory UserDelete.DeleteUser(){
    return UserDelete(loading:false, delete: false,  deleteSuccess:false);
  }

  factory UserDelete.DeleteResult(bool success ){
    return UserDelete(loading:false, delete: true, deleteSuccess:success);
  }

}

