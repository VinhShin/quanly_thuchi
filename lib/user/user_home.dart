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
import 'bloc/user_bloc.dart';
import 'package:quanly_thuchi/model/user.dart';
import 'bloc/user_event.dart';
import 'bloc/user_state.dart';
import 'user_home_edit.dart';
import 'package:quanly_thuchi/base_widget/text_base.dart';
import 'package:quanly_thuchi/base_widget/edit_base.dart';

class UserHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _userHome();
  }
}

class _userHome extends State<UserHome> {
  UserBloc _userBloc;
  List<User> users;
  TextEditingController subUserName = new TextEditingController();
  TextEditingController subPassName = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users = new List();
    _userBloc = new UserBloc();
    _userBloc.dispatch(GetAllUser());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener(
        bloc: _userBloc,
        listener: (BuildContext context, UserState state) {
          if (state is UserAdd && state.loading) {
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
          } else if (state is UserAdd && state.loaded) {
            Scaffold.of(context)..hideCurrentSnackBar();
            _showDialogRegisterResult(state.addSuccess
                ? "Đăng ký thành công"
                : "Tài khoản đăng ký đã tồn tại");
            if (state.addSuccess) {
              subUserName.text = "";
              subPassName.text = "";
            }
          } else if (state is UserDelete) {
            Scaffold.of(context)..hideCurrentSnackBar();
            _showDialogRegisterResult(state.deleteSuccess
                ? "Xóa tài khoản thành công"
                : "Tài khoản không tồn tại");

            subUserName.text = "";
            subPassName.text = "";
          } else if (state is UserUpdate) {
            Scaffold.of(context)..hideCurrentSnackBar();
            _showDialogRegisterResult(state.updateSuccess
                ? "Cập nhật tài khoản thành công"
                : "Cập nhật tài khoản thất bại");
            subUserName.text = "";
            subPassName.text = "";
          }
        },
        child: BlocBuilder(
            bloc: _userBloc,
            builder: (BuildContext context, UserState state) {
              if (state is UsersLoaded) {
                users = state.users;
              }
              return Stack(
                children: <Widget>[
                  ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, position) {
                      return Container(
                          height: 50,
                          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: GestureDetector(
                            onTap: () async {
                              _showDialog(user: users[position]);
                            },
                            child: Card(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 6, bottom: 6, left: 10, right: 10),
                                  child: new Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            users[position].user,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 18.0),
                                          )),
                                      Expanded(
                                          flex: 1,
                                            child: Text(
                                              users[position].pass,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                      Expanded(
                                        child: GestureDetector(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            height: 30,
                                            child: GestureDetector(
                                              onTap: () {
                                                _showDialogConfirmDeleteUser(
                                                    context,
                                                    _userBloc,
                                                    users[position].user);
                                              },
                                              child: Icon(Icons.delete),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ));
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.all(30),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          onPressed: () {
                            this.subPassName.text = "";
                            this.subUserName.text = "";
                            _showDialog();
                          },
                          child: Icon(
                            Icons.add,
                          ),
                          backgroundColor: Colors.pink,
                        ),
                      ))
                ],
              );
            }));
  }

  _showDialog({User user}) {
    if (user != null) {
      this.subUserName.text = user.user;
      this.subPassName.text = user.pass;
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(user == null ? 'Thêm tài khoản' : "Cập nhật tài khoản"),
            content: Container(
              height: 168,
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: 350,
                      height: 45,
                      child: TextField(
                        maxLines: null,
                        minLines: null,
                        expands: true,
                        enabled: user == null,
                        controller: this.subUserName,
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(top: 10, left: 5),
                            hintText: "Tên tài khoản",
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            suffixStyle: const TextStyle(color: Colors.green)),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    padding: EdgeInsets.only(bottom: 5),
                    width: 350,
                    height: 45,
                    child: TextField(
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      controller: this.subPassName,
                      decoration: new InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10, left: 5),
                          hintText: "Mật khẩu",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          suffixStyle: const TextStyle(color: Colors.green)),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Đóng", style: TextStyle(color: Colors.white)),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: RaisedButton(
                          color: Colors.blueAccent,
                          child: new Text(user == null ? "Thêm" : "Cập nhật", style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            if (this.subPassName.text.length == 0 ||
                                this.subUserName.text.length == 0) {
                              _showDialogRegisterResult(
                                  "Tài khoản và mật khẩu không được để trống");
                            } else {
                              if (user == null) {
                                _userBloc.dispatch(UserEventRegister(
                                    userName: this.subUserName.text,
                                    userPass: this.subPassName.text));
                              } else {
                                user.setPass = this.subPassName.text;
                                _userBloc.dispatch(
                                    UserUpdateEvent(userUpdate: user));
                              }
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
//            actions: <Widget>[
//              new FlatButton(
//                child: new Text('Đóng'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//              new FlatButton(
//                child: new Text(user == null ? "Thêm" : "Cập nhật"),
//                onPressed: () {
//                  if (this.subPassName.text.length == 0 ||
//                      this.subUserName.text.length == 0) {
//                    _showDialogRegisterResult(
//                        "Tài khoản và mật khẩu không được để trống");
//                  } else {
//                    if (user == null) {
//                      _userBloc.dispatch(UserEventRegister(
//                          userName: this.subUserName.text,
//                          userPass: this.subPassName.text));
//                    } else {
//                      user.setPass = this.subPassName.text;
//                      _userBloc.dispatch(UserUpdateEvent(userUpdate: user));
//                    }
//                    Navigator.of(context).pop();
//                  }
//                },
//              ),
//            ],
          );
        });
  }

  void _showDialogRegisterResult(String content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Thông báo"),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogConfirmDeleteUser(
      BuildContext context, UserBloc userBloc, String user) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Xóa Tài khoản"),
          content: new Text("Bạn có chắc muốn xóa tài khoản này"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Đồng ý"),
              onPressed: () {
                userBloc.dispatch(UserEventDelete(userName: user));
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
