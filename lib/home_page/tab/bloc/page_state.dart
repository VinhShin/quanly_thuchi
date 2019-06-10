import 'package:quanly_thuchi/model/re_ex_data.dart';


class PageState{

}

class PageLoadingData extends PageState{
  PageLoadingData();
}

class PageLoadedData extends PageState{
  List<ReExData> listData;
  PageLoadedData({this.listData});
}