import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thuchi/constant.dart';
import 'package:thuchi/category/bloc/cate_bloc.dart';
import 'package:thuchi/category/bloc/cate_event.dart';
import 'package:thuchi/category/bloc/cate_state.dart';
import 'package:thuchi/model/category_model.dart';
import 'package:thuchi/base_widget/text_base.dart';

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
  int _radioValue1 = REVENUE_TYPE;
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

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          // here we display the title corresponding to the fragment
          // you can instead choose to have a static title
          title: new Text("Quản lý danh mục"),
        ),
        body: BlocListener(
          bloc: _cateBloc,
          listener: (BuildContext context, CateState state) {
            if (state is CateLoading) {
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
            } else if (state is CateLoad) {
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
                } else if (state is CateEdit) {
                  if (_listCate.isNotEmpty &&
                      _listCate.length > state.position) {
                    _cateController.text = _listCate[state.position].name;
                    currentCate = _listCate[state.position];
                    _radioValue1 = currentCate.type;
                    buttonText = "Cập nhật";
                    _cateBloc.dispatch(EmptyEvent());
                  }
                } else if (state is CateNameAdd) {
                  buttonText = "Thêm";
                }

                return Column(children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                        child: Container(
                            width: 100,
                            height: 43,
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
                                  maxLines: null,
                                  minLines: null,
                                  expands: true,
                                  decoration: new InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(top: 10, left: 5),
                                      hintText: "Thêm danh mục",
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.teal)),
                                      suffixStyle:
                                          const TextStyle(color: Colors.green)),
                                )))),
                  ]),Row(children: <Widget>[
                    Expanded(
                        child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(children: createRadioListUsers()),
                        ),),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      width: 110,
                      height: 43,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          if (buttonText == "Thêm") {
                            _cateBloc.dispatch(AddCate(_cateController.text, this._radioValue1));
                          } else {
                            if (currentCate != null) {
                              String oldCateName = currentCate.name;
                              currentCate.setName = _cateController.text;
                              currentCate.type = _radioValue1;
                              _cateBloc
                                  .dispatch(Update(categoryModel: currentCate,oldCateName: oldCateName));
                            }
                          }
                          setState(() {
                            _cateController.text = "";
                          });
                        },
                        child: Text(buttonText,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
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

  List<Widget> createRadioListUsers() {
    List<Widget> widgets = [];
    widgets.add(SizedBox(
      width: 120,
      child: RadioListTile(
        dense: false,
        value: REVENUE_TYPE,
        groupValue: _radioValue1,
        title: Text("Thu"),
        onChanged: (currentUser) {
          _handleRadioValueChange1(REVENUE_TYPE);
        },
        selected: _radioValue1 == REVENUE_TYPE,
        activeColor: Colors.green,
      ),
    ));
    widgets.add(SizedBox(
      width: 120,
      child: RadioListTile(
        value: EXPENDTURE_TYPE,
        groupValue: _radioValue1,
        title: Text("Chi"),
        onChanged: (currentUser) {
          _handleRadioValueChange1(EXPENDTURE_TYPE);
        },
        selected: _radioValue1 == EXPENDTURE_TYPE,
        activeColor: Colors.green,
      ),
    ));
    return widgets;
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
        height: 50,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: GestureDetector(
          onTap: () async {
            cateBloc.dispatch(CateChange(position));
          },
          child: Card(
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 6, bottom: 6, left: 10, right: 10),
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
