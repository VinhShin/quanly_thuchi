import 'package:flutter/material.dart';

class PageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
        child: new Column(
    mainAxisSize:MainAxisSize.min,
            children: <Widget>[
          Text("Tiền đầu ngày"),
          Text("Tiền thu"),
          Text("Tiền chi"),
          Text("Tổng:"),
          Text("Tiền cuối ngày"),
        ])),
        Flexible(
          flex:2,
          child: ListView.builder(
            itemCount: 30,
            itemBuilder: (context, position) {
              return Container(
                  margin: EdgeInsets.all(5),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        position.toString(),
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ),
                  ));
            },
          ),
        )
      ],
    );
  }
}
