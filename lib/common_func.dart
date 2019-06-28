import 'package:flutter/material.dart';

String formatMoney(String money) {
  String newFormat = "";
  for (int i = 0; i < money.length; i++) {
    newFormat = money[money.length-i-1] + newFormat;
    if ((i+1) % 3 == 0 && i != money.length-1) {
      newFormat = "." + newFormat;
    }
  }
  return newFormat;
}


void alertNotify(BuildContext context, String title, String content) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}