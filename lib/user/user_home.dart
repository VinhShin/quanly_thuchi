import 'package:flutter/material.dart';
import 'package:quanly_thuchi/base_widget/text_base.dart';
import 'package:quanly_thuchi/base_widget/edit_base.dart';
import 'package:quanly_thuchi/user/bloc/user_bloc.dart';
import 'package:quanly_thuchi/user/bloc/user_event.dart';
import 'package:quanly_thuchi/user/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserHome();
  }
}

class _UserHome extends State<UserHome> {
  TextEditingController subUserName = new TextEditingController();
  TextEditingController subPassName = new TextEditingController();
  UserBloc _userBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userBloc = new UserBloc();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener(
        bloc: _userBloc,
        listener: (BuildContext context, UserState state) {
          if (state.loaded) {
            _showDialogRegisterResult(state.addSuccess);
            if(state.addSuccess) {
              setState(() {
                subUserName.text = "";
                subPassName.text = "";
              });
            }
          }
        },
        child: Column(
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
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      if (this.subPassName.text.length == 0 ||
                          this.subUserName.text.length == 0) {
                        _showDialogRegisterNotValid();
                      } else {
                        _userBloc.dispatch(UserEventRegister(
                            userName: this.subUserName.text,
                            userPass: this.subPassName.text));
                      }
                    },
                    child: Container(
                        width: 150,
                        height: 45,
                        child: Center(
                          child: Text("Thêm tài khoản",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ))),
              )
            ]));
  }

  void _showDialogRegisterResult(bool sucess) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Thông báo"),
          content: new Text(
              sucess ? "Đăng ký thành công" : "Tài khoản đăng ký đã tồn tại"),
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

  void _showDialogRegisterNotValid() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Thông báo"),
          content: new Text("Tài khoản và mật khẩu không được để trống"),
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
}
