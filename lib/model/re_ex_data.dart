class ReExData {
  String _id;
  int _type;
  double _money;
  String _dateTime;
  String _note;

  String get id => _id;
  int get type => _type;
  double get money => _money;
  String get dateTime => _dateTime;
  String get note => _note;

  ReExData(this._type, this._money, this._dateTime, this._note,[this._id]);

  ReExData.map(dynamic obj) {
    this._id = obj["id"];
    this._type = obj['type'];
    this._money = obj['money'];
    this._dateTime = obj['date_time'];
    this._note = obj["note"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["type"] = _type;
    map["money"] = _money;
    map['date_time'] = _dateTime;
    map['note'] = _note;

    return map;
  }

  ReExData.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._type = map['type'];
    this._money = map['money'];
    this._dateTime = map['date_time'];
    this._note = map['note'];
  }
}
