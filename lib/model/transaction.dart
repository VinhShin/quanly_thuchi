class Transaction {
  String _id;
  int _type;
  int _money;
  String _date;
  String _time;
  String _note;
  String _cateId;
  String _subUserId;

  String get id => _id;
  int get type => _type;
  int get money => _money;
  String get date => _date;
  String get time => _time;
  String get note => _note;
  String get cateId => _cateId;
  String get subUserId => _subUserId;

  set setId(id) => _id =id;
  set setType(type) => _type = type;
  set setMoney(money) => _money = money;
  set setDate(date) => _date = date;
  set setTime(time) => _time = time;
  set setNote(note) => _note = note;
  set setCate(cate) => _cateId = cate;
  set setSubUserId(subUserId) => _subUserId = subUserId;

  Transaction(this._type, this._money, this._date, this._time, this._note,this._cateId,this._subUserId,[this._id]);

  Transaction.map(dynamic obj) {
    this._id = obj["id"];
    this._type = obj['type'];
    this._money = obj['money'];
    this._date = obj['date'];
    this._time = obj['time'];
    this._note = obj["note"];
    this._cateId = obj["cate_id"];
    this._subUserId = obj["sub_user"];
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
    map['sub_user'] = _subUserId;
    return map;
  }

  Transaction.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._type = map['type'];
    this._money = map["money"];
    this._date = map['date'];
    this._time = map['time'];
    this._note = map['note'];
    this._cateId = map['cate_id'];
    this._subUserId = map['sub_user'];
  }
}
