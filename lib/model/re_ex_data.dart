class ReExData {
  String _id;
  int _type;
  double _money;
  String _date;
  String _time;
  String _note;
  String _cateId;

  String get id => _id;
  int get type => _type;
  double get money => _money;
  String get date => _date;
  String get time => _time;
  String get note => _note;
  String get cateId => _cateId;

  set setId(id) => _id =id;

  ReExData(this._type, this._money, this._date, this._time, this._note,this._cateId,[this._id]);

  ReExData.map(dynamic obj) {
    this._id = obj["id"];
    this._type = obj['type'];
    this._money = obj['money'];
    this._date = obj['date'];
    this._time = obj['time'];
    this._note = obj["note"];
    this._cateId = obj["cate_id"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["type"] = _type;
    map["money"] = _money;
    map['date'] = _date;
    map['time'] = _time;
    map['note'] = _note;
    map['cate_id'] = _cateId;
    return map;
  }

  ReExData.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._type = map['type'];
    this._money = map['money'];
    this._date = map['date'];
    this._time = map['time'];
    this._note = map['note'];
    this._cateId = map['cate_id'];
  }
}
