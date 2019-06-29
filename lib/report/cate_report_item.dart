import 'package:flutter/material.dart';

class CateReportItem extends StatelessWidget {
  String title;
  String subTitle;

  CateReportItem(this.title, this.subTitle);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Spacer(),
              Text(
                "Chi Tiết",
                style: TextStyle(color: Colors.blueAccent),
              )
            ],
          ),
        ),
      ),
    );
  }
}
