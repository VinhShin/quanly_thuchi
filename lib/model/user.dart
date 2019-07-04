class User {
  String _user;
  String _pass;
  String _parent_id;
  String _parent_name;

  String get user => _user;
  String get pass => _pass;
  String get parent => _parent_id;
  String get parentName => _parent_name;

  set setUser(user) => _user =user;
  set setPass(pass) => _pass = pass;
  set setParent(parentId) => _parent_id = parentId;
  set setParentName(parentName) => _parent_name = parentName;


  User(this._user, this._pass, this._parent_id, this._parent_name);

  User.map(dynamic obj) {
    this._user = obj["user"];
    this._pass = obj['pass'];
    this._parent_id = obj['parent_id'];
    this._parent_name = obj['parent_name'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["user"] = _user;
    map["pass"] = _pass;
    map["parent_id"] = _parent_id;
    map['parent_name'] = _parent_name;
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    this._user = map["user"];
    this._pass = map['pass'];
    this._parent_id = map["parent_id"];
    this._parent_name = map['parent_name'];
  }
}
