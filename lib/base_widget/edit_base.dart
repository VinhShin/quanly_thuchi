import 'package:flutter/material.dart';


class EditBase extends StatelessWidget{

  TextEditingController controller;
  int numberLine = 1;
  String hint;
  bool isMultiline = false;
  bool isMoney = false;
  bool isPassWord = false;
  EditBase(String hint, {this.isMultiline, this.controller, this.isMoney, this.isPassWord}){
    this.hint = hint;
      this.isMultiline = isMultiline??false;
      this.isMoney = isMoney??false;
      this.isPassWord = isPassWord??false;
  }

  @override
  Widget build(BuildContext context) {
    if(this.isMultiline){
      numberLine = 5;
    }
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 10,left: 10, right: 10),
      child:  new Theme(
        data: new ThemeData(
          primaryColor: Colors.redAccent,
          primaryColorDark: Colors.red,
        ),
        child: new TextField(
          obscureText: this.isPassWord,
          controller: controller,
          keyboardType: isMoney?TextInputType.number:TextInputType.multiline,
          maxLines: this.numberLine,
          decoration: new InputDecoration(
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              hintText: hint,
              suffixStyle: const TextStyle(color: Colors.green)),
        ),
      ));
    }
}