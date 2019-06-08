import 'package:flutter/material.dart';


class TextBase extends StatelessWidget{

  String text;

  TextBase(String text){
    this.text = text;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 10,left: 10),
      child: Text(this.text,style: TextStyle(fontSize: 21)),
    );}
}