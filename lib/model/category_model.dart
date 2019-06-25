class CategoryModel{
  int _id;
  String _name;

  get id => _id;
  get name => _name;

  set setName(name) => _name =name;

  CategoryModel(this._id, this._name);


  CategoryModel.map(dynamic obj) {
    this._id = obj["id"];
    this._name = obj['name'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    return map;
  }

  CategoryModel.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._name = map['name'];
  }
}