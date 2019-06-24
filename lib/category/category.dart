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
  _category();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cateBloc = new CateBloc();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void setCategory(String category){
    setState(() {
      currentCateSelect:category;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    List<String> listCategory = new List();
    listCategory.add("Danh Muc 1");
    listCategory.add("Danh Muc 2");
    listCategory.add("Danh Muc 3");
    listCategory.add("Danh Muc 4");
    listCategory.add("Danh Muc 5");
    listCategory.add("Danh Muc 6");
    listCategory.add("Danh Muc 7");

    final TextStyle valueStyle = Theme
        .of(context)
        .textTheme
        .body1;

    return Scaffold(
        appBar: new AppBar(
          // here we display the title corresponding to the fragment
          // you can instead choose to have a static title
          title: new Text("Quản lý danh mục"),
        ),
        body: BlocListener(
          bloc: _cateBloc,
          listener: (BuildContext context, CateState state) {
            if (state.currentStep == STEP_LOADING) {
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
            } else if (state.currentStep == CONNECT_FAIL) {
//          _showDialogNoNetWork();
              alertNotify(this.context, "Tác vụ thất bại",
                  "Bạn cần kết nối internet để thực hiện tác vụ này");
            } else if (state.currentStep == STEP_INSERT && state.status) {
              Navigator.pop(context, true);
            } else if (state.currentStep == STEP_DELETE && state.status) {
              Navigator.pop(context, true);
            } else if (state.currentStep == STEP_UPDATE && state.status) {
              Navigator.pop(context, true);
            }
          },
          child: BlocBuilder(
              bloc: _cateBloc,
              builder: (BuildContext context, CateState state) {
                return Column(children: <Widget>[
                  Flexible(
//                    child: Text("sss"),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: EditBase("Thêm danh mục"),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          width: 120,
                          height: 55,
                          child: RaisedButton(
                              color: Colors.blue,
                              onPressed: () {},
                              child: Text('Thêm',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white)),
                                  ),
                      )


                    ]),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: listCategory.length,
                      itemBuilder: (context, position) {
                        return ItemRow(
                            cate: listCategory[position],
                            cateBloc: this._cateBloc);
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

class TextKeyValue extends StatelessWidget {
  final textStyle = TextStyle(
    fontSize: 18,
  );
  String title;
  String value;

  TextKeyValue(title, value) {
    this.title = title;
    this.value = value;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        margin: EdgeInsets.only(top: 10),
        child: new Row(
          children: <Widget>[
            Text(title, textAlign: TextAlign.left, style: textStyle),
            Spacer(),
            Text(value, textAlign: TextAlign.left, style: textStyle),
          ],
        ));
  }
}

class ItemRow extends StatelessWidget {
  final String cate;
  final CateBloc cateBloc;

  const ItemRow({Key key, @required this.cate, this.cateBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () async {
//            cateBloc.dispatch(event)
          },
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Row(
                  children: <Widget>[
                    Text(
                      cate,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                )),
          ),
        ));
  }
}
