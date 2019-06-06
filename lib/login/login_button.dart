import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: RaisedButton(
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: _onPressed,
        child: Text('Login',),
      ),
    );
  }
}
