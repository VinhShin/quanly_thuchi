import 'package:meta/meta.dart';
import 'package:thuchi/model/category_model.dart';


class CateState{
  CateState();
}

class CateLoading extends CateState{

}

class CateLoad extends CateState{
  List<CategoryModel> listCategory;
  CateLoad(this.listCategory);
}

class CateEdit extends CateState{
  int position;
  CateEdit(this.position);
}

class CateNameAdd extends CateState{

}

class CateEmpty extends CateState{}
