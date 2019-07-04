import 'package:flutter/material.dart';
import 'package:quanly_thuchi/base_widget/text_base.dart';
import 'package:quanly_thuchi/base_widget/edit_base.dart';
import 'package:quanly_thuchi/user/bloc/user_bloc.dart';
import 'package:quanly_thuchi/user/bloc/user_event.dart';
import 'package:quanly_thuchi/user/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanly_thuchi/model/user.dart';

class UserHomeEdit extends StatefulWidget {

  UserBloc userBloc;
  User user;

  UserHomeEdit({this.user, this.userBloc});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _userHomeEdit(user: this.user);
  }
}

class _userHomeEdit extends State<UserHomeEdit> {
  TextEditingController subUserName = new TextEditingController();
  TextEditingController subPassName = new TextEditingController();
  UserBloc userBloc;
  User user;

  _userHomeEdit({this.user,this.userBloc});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener(
      bloc: userBloc,
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
        }
        else if (state is UserAdd && state.loaded) {
          Scaffold.of(context)
            ..hideCurrentSnackBar();
          _showDialogRegisterResult(state.addSuccess
              ? "Đăng ký thành công"
              : "Tài khoản đăng ký đã tồn tại");
          if (state.addSuccess) {
            setState(() {
              subUserName.text = "";
              subPassName.text = "";
            });
          }
        } else if (state is UserDelete) {
          Scaffold.of(context)
            ..hideCurrentSnackBar();
          _showDialogRegisterResult(state.deleteSuccess
              ? "Xóa tài khoản thành công"
              : "Tài khoản không tồn tại");
          if (state.deleteSuccess) {
            setState(() {
              subUserName.text = "";
              subPassName.text = "";
            });
          }
        }
      },
      child: Scaffold(
        appBar: new AppBar(
          // here we display the title corresponding to the fragment
          // you can instead choose to have a static title
          title: new Text(user == null ? "Thêm tài khoản" : "Cập nhật tài khoản"),
        ),
          body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextBase("Tài khoản con"),
            EditBase(
              "123",
              controller: this.subUserName,
              isMoney: false,
            ),
            TextBase("Mật khẩu"),
            EditBase(
              "******",
              controller: this.subPassName,
              isMoney: false,
              isPassWord: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        if (this.subUserName.text.length == 0) {
                          _showDialogRegisterResult(
                              "Tài khoản và mật khẩu không được để trống");
                        } else {userBloc.dispatch(UserEventDelete(
                              userName: this.subUserName.text));
                        }
                      },
                      child: Container(
                          width: 120,
                          height: 45,
                          child: Center(
                            child: Text("Xóa tài khoản",
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                          ))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        if (this.subPassName.text.length == 0 ||
                            this.subUserName.text.length == 0) {
                          _showDialogRegisterResult(
                              "Tài khoản và mật khẩu không được để trống");
                        } else {
                          userBloc.dispatch(UserEventRegister(
                              userName: this.subUserName.text,
                              userPass: this.subPassName.text));
                        }
                      },
                      child: Container(
                          width: 120,
                          height: 45,
                          child: Center(
                            child: Text("Thêm tài khoản",
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                          ))),
                )
              ],)

          ]),
    ));
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
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}

void _showDialog(BuildContext context, UserBloc userBloc, String user) {
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
              userBloc.dispatch(
                  UserEventDelete(userName: user));
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

