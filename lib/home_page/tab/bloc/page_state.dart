import 'package:quanly_thuchi/model/transaction_section.dart';


class PageState{

}

class PageLoadingData extends PageState{
  PageLoadingData();
}

class PageLoadedData extends PageState{
  String dateTime;//dung de compare voi cac section khac
  TransactionSection section;
  PageLoadedData({this.section, this.dateTime});
}