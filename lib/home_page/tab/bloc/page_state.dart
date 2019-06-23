import 'package:quanly_thuchi/model/transaction_section.dart';


class PageState{

}

class PageLoadingData extends PageState{
  String time;
  PageLoadingData({this.time});
}

class PageLoadedData extends PageState{
  TransactionSection section;
  PageLoadedData({this.section});
}
