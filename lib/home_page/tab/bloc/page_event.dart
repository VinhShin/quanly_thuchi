

class PageEvent{

}

class PageLoadData extends PageEvent{
  String _date;
  String get date => _date;
  PageLoadData(this._date);
}

class OptionLoadData extends PageEvent{
  DateTime fromDate;
  DateTime toDate;
  OptionLoadData(this.fromDate, this.toDate);
}

class OptionStart extends PageEvent{

}