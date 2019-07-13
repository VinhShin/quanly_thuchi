class CategoryModel{
  int _id;
  String _name;
  int _type;

  get id => _id;
  get name => _name;
  get type => _type;

  set setName(name) => _name =name;
  set type(type) => _type = type;

  CategoryModel(this._id, this._name, this._type);

  CategoryModel.map(dynamic obj) {
    this._id = obj["id"];
    this._name = obj['name'];
    this._type = obj["type"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    map["type"] = _type;
    return map;

  }

  CategoryModel.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._name = map['name'];
    this._type = map["type"];
  }
}