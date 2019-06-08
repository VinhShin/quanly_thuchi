import 'package:flutter/material.dart';

class PageSection extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(20),
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextKeyValue("Tiền đầu ngày:","200.000"),
        TextKeyValue("Tiền thu:", "50.000"),
        TextKeyValue("Tiền chi:","40.000"),
        TextKeyValue("Tổng:","90.000"),
        TextKeyValue("Tiền cuối ngày:", "290.000"),
        Container(
          margin: EdgeInsets.only(top: 10,bottom: 10),
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width,1),
            painter: Drawhorizontalline(),
          ),
        ),
        Flexible(
          flex: 1,
          child: ListView.builder(
            itemCount: 30,
            itemBuilder: (context, position) {
              return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Row(
                        children: <Widget>[
                          Text(
                            "Danh muc",
                            style: TextStyle(fontSize: 22.0),
                          ), Spacer(),
                          Text(
                            "Số tiền",
                            style: TextStyle(fontSize: 22.0),
                          )
                        ],
                      )
                    ),
                  ));
            },
          ),
        )
      ],
    ));
  }

}

class Drawhorizontalline extends CustomPainter {
  Paint _paint;

  Drawhorizontalline() {
    _paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {

    canvas.drawLine(Offset(0.0, 0.0), Offset(size.width, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TextKeyValue extends StatelessWidget{

  final textStyle = TextStyle(
    fontSize: 21,
  );
  String title;
  String value;
  TextKeyValue(title,value){
    this.title = title;
    this.value = value;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Row(
      children: <Widget>[
        Text(title,textAlign: TextAlign.left, style: textStyle),
        Spacer(),
        Text(value,textAlign: TextAlign.left, style: textStyle),
      ],
    );
  }
}

