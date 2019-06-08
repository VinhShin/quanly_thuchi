import 'package:flutter/material.dart';


class EditBase extends StatelessWidget{

  TextEditingController controller;
  int numberLine = 1;
  String hint;
  bool isMultiline = false;
  EditBase(String hint, {this.isMultiline, this.controller}){
    this.hint = hint;
      this.isMultiline = isMultiline??false;
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
          controller: controller,
          keyboardType: TextInputType.multiline,
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