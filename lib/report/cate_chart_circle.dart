import 'package:flutter/material.dart';
import 'package:thuchi/pie_chart.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import "package:thuchi/common_func.dart";

class CateChartCircle extends StatelessWidget {
  Map<String, double> mapEx = new Map();
  List<Color> color;
  BuildContext context;
  List<CircularSegmentEntry> listSegmentEntryEx;
  String title;

  CateChartCircle(this.context, this.mapEx, this.color, this.listSegmentEntryEx,
      this.title);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.red,
              ),
            ),
          ),
          Container(
            child: PieChart(
              dataMap: mapEx,
              legendFontColor: Colors.blueGrey[900],
              legendFontSize: 14.0,
              legendFontWeight: FontWeight.w500,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery.of(context).size.width / 2.7,
              showChartValuesInPercentage: true,
              showChartValues: true,
              showChartValuesOutside: true,
              chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
              showLegends: true,
            ),
          ),
          Container(
            width: 200,
              height: 100,
              child: new ListView.builder(
                  itemCount: mapEx.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Text(
                                  "\t" + listSegmentEntryEx[index].rankKey,
                                  style: TextStyle(color: color[index])),
                            )),
                        Expanded(
                            flex: 1,
                              child: Text(
                                  formatMoney((listSegmentEntryEx[index].value)
                                      .toInt()
                                      .toString()),
                                  style: TextStyle(color: color[index])),
                            )
                      ],
                    );
//                            return new Text(:\t'+listSegmentEntry[index].value.toString(),style:TextStyle(color: listSegmentEntry[index].color),);
                  })),
        ],
      ),
    );
  }
}
