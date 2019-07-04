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

class PageLoadOption extends PageState{
  TransactionSection section;
  PageLoadOption(this.section);
}

class PageLoadingOption extends PageState{

}

class PageInitOption extends PageState{}