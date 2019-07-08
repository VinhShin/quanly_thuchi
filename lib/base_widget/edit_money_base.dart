import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditMoneyBase extends StatelessWidget {
  TextEditingController controller;
  int numberLine = 1;
  String hint;
  bool isMultiline = false;
  bool isMoney = false;
  bool isPassWord = false;

  EditMoneyBase(String hint,
      {this.isMultiline, this.controller, this.isMoney, this.isPassWord}) {
    this.hint = hint;
    this.isMultiline = isMultiline ?? false;
    this.isMoney = isMoney ?? false;
    this.isPassWord = isPassWord ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (this.isMultiline) {
      numberLine = 5;
    }
    // TODO: implement build
    return Container(
        height: 50,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: new Theme(
          data: new ThemeData(
            primaryColor: Colors.redAccent,
            primaryColorDark: Colors.red,
          ),
          child: TextField(
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              new CurrencyInputFormatter()
            ],
            obscureText: this.isPassWord,
            controller: controller,
            keyboardType: TextInputType.number,
            maxLines: null,
            minLines: null,
            expands: true,
            decoration: new InputDecoration(
                contentPadding: EdgeInsets.only(top: 10, left: 5),
                hintText: "200.000",
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
                suffixStyle: const TextStyle(color: Colors.green)),
          )
          ,
        ));
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = new NumberFormat("###,###", "pt-br");

    String newText = formatter.format(value / 1);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
