

class PageEvent{

}

class PageLoadData extends PageEvent{
  String _date;
  String get date => _date;
  PageLoadData(this._date);
}
