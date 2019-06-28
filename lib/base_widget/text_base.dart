import 'package:flutter/material.dart';


class TextBase extends StatelessWidget{

  String text;
  double leftMargin = 10;
  TextBase(String text, {marginLeft}){
    this.text = text;
    this.leftMargin = marginLeft??this.leftMargin;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 10,left: leftMargin),
      child: Text(this.text,style: TextStyle(fontSize: 18)),
    );}
}