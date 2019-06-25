import 'package:flutter/material.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_state.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_event.dart';
import 'package:quanly_thuchi/model/transaction.dart' as my;
import 'package:quanly_thuchi/model/transaction_header.dart';
import 'package:quanly_thuchi/model/transaction_section.dart';
import 'package:quanly_thuchi/constant.dart';
import 'package:quanly_thuchi/edit_revenue_expenditure/edit_revenue_expendture.dart';
import 'package:quanly_thuchi/common_func.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quanly_thuchi/repository/firestorage_repository.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quanly_thuchi/category/bloc/cate_bloc.dart';
import 'package:quanly_thuchi/category/bloc/cate_event.dart';
import 'package:quanly_thuchi/category/bloc/cate_state.dart';
import 'package:quanly_thuchi/base_widget/edit_base.dart';
import 'package:quanly_thuchi/model/category_model.dart';

class Category extends StatefulWidget {
  Category();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _category();
  }
}

class _category extends State<Category> {
  CateBloc _cateBloc;
  String currentCateSelect = "";
  String buttonText = "Thêm";
  List<CategoryModel> _listCate;
  TextEditingController _cateController;
  CategoryModel currentCate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cateBloc = new CateBloc();
    _cateBloc.dispatch(LoadCate());
    _listCate = new List();
    _cateController = new TextEditingController();
//    _cateController.addListener((){
//      if(_cateController.text.length == 0) {
//        setState(() {
//          buttonText = "Thêm";
//        });
//      }
//    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void setCategory(String category) {
//    setState(() {
//      currentCateSelect:
//      category;
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:false,
        appBar: new AppBar(
          // here we display the title corresponding to the fragment
          // you can instead choose to have a static title
          title: new Text("Quản lý danh mục"),
        ),
        body: BlocListener(
          bloc: _cateBloc,
          listener: (BuildContext context, CateState state) {
            if(state is CateLoading){
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Đang xử lý...'),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                );
            } else if(state is CateLoad){
              Scaffold.of(context)..hideCurrentSnackBar();
            }
          },
          child: BlocBuilder(
              bloc: _cateBloc,
              builder: (BuildContext context, CateState state) {
                if (state is CateLoad && state.listCategory != null) {
                  _listCate = state.listCategory;
                  buttonText = "Thêm";
                  _cateController.text = "";
                  _cateBloc.dispatch(EmptyEvent());
                }

                else if (state is CateEdit) {
                  if (_listCate.isNotEmpty &&
                      _listCate.length > state.position) {
                    _cateController.text = _listCate[state.position].name;
                    currentCate = _listCate[state.position];
                    buttonText = "Cập nhật";
                    _cateBloc.dispatch(EmptyEvent());
                  }
                } else if(state is CateNameAdd){
                  buttonText = "Thêm";
                }

                return Column(children: <Widget>[
              Row(children: <Widget>[
                      Expanded(
                          child: Container(
                              margin:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                              child: new Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.redAccent,
                                  primaryColorDark: Colors.red,
                                ),
                                child: new TextField(
                                  onChanged: (text) {
                                    if (text.length == 0) {
                                      _cateBloc.dispatch(ChangeTextToAdd());

                                    }
                                  },
                                  controller: _cateController,
                                  decoration: new InputDecoration(
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.teal)),
                                      hintText: "Thêm danh mục",
                                      suffixStyle:
                                          const TextStyle(color: Colors.green)),
                                ),
                              ))),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        width: 120,
                        height: 55,
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            if(buttonText == "Thêm") {
                              _cateBloc.dispatch(AddCate(_cateController.text));
                            } else{
                              if(currentCate != null) {
                                currentCate.setName = _cateController.text;
                                _cateBloc.dispatch(Update(categoryModel:currentCate));
                              }
                            }
                            setState(() {
                              _cateController.text = "";
                            });
                          },
                          child: Text(buttonText,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                      )
                    ]),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _listCate.length,
                      itemBuilder: (context, position) {
                        return ItemRow(
                          cate: _listCate[position],
                          cateBloc: this._cateBloc,
                          position: position,
                        );
                      },
                    ),
                  )
                ]);
              }),
        ));
  }
}

class Drawhorizontalline extends CustomPainter {
  Paint _paint;

  Drawhorizontalline() {
    _paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0.0, 0.0), Offset(size.width, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ItemRow extends StatelessWidget {
  final CategoryModel cate;
  final CateBloc cateBloc;
  final int position;

  const ItemRow({Key key, @required this.cate, this.cateBloc, this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () async {
            cateBloc.dispatch(CateChange(position));
          },
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      cate.name,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 40,
                        child: GestureDetector(
                          onTap: () {
                            _showDialog(context, cateBloc, cate.id);
                          },
                          child: Icon(Icons.delete),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}

void _showDialog(BuildContext context, CateBloc cateBloc, int id) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Xóa danh mục"),
        content: new Text("Bạn có chắc muốn xóa danh mục này"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Đồng ý"),
            onPressed: () {
              cateBloc.dispatch(Delete(id: id));
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text("Hủy"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
