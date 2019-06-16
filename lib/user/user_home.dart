import 'package:flutter/material.dart';
import 'package:quanly_thuchi/base_widget/text_base.dart';
import 'package:quanly_thuchi/base_widget/edit_base.dart';

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
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
          "xxx",
          controller: this.subPassName,
          isMoney: false,
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          child: RaisedButton(
              color: Colors.blue,
              onPressed: () {},
              child: Container(
                  width: 150,
                  height: 45,
                  child: Center(
                    child: Text("Thêm tài khoản",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ))),
        )
      ],
    );
  }
}
