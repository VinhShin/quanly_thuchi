import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quanly_thuchi/category/bloc/cate_bloc.dart';
import 'package:quanly_thuchi/edit_revenue_expenditure/input_down.dart';
import 'package:quanly_thuchi/report/report_bloc/report_bloc.dart';
import 'package:quanly_thuchi/report/report_bloc/report_event.dart';
import 'package:quanly_thuchi/report/report_bloc/report_state.dart';
import 'package:quanly_thuchi/pie_chart.dart';
import 'package:quanly_thuchi/common_func.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ReportBloc _reportBloc;
  int sumEx;
  int sumRe;
  List<Color> colors;
  Map<String, double> mapEx = new Map();
  Map<String, double> mapRe = new Map();
  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDateTo = DateTime.now();
  List<DropdownMenuItem<String>> listDropDonwMenuItem = new List();
  String typeReport = "d";
  List<CircularStackEntry> circularDataEx = <CircularStackEntry>[];
  List<CircularStackEntry> circularDataRe = <CircularStackEntry>[];

/////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    _reportBloc = new ReportBloc();
    listDropDonwMenuItem
        .add(new DropdownMenuItem(value: "d", child: new Text("Ngày")));
    listDropDonwMenuItem
        .add(new DropdownMenuItem(value: "w", child: new Text("Tuần")));
    listDropDonwMenuItem
        .add(new DropdownMenuItem(value: "m", child: new Text("Tháng")));
    listDropDonwMenuItem
        .add(new DropdownMenuItem(value: "y", child: new Text("Năm")));
    listDropDonwMenuItem
        .add(new DropdownMenuItem(value: "d2d", child: new Text("Tùy chọn")));
    colors = [
      Color(0xFFff7675),
      Color(0xFF74b9ff),
      Color(0xFF55efc4),
      Color(0xFFFFD600),
      Color(0xFFa29bfe),
      Color(0xFFfd79a8),
      Color(0xFFe17055),
      Color(0xFF00b894),
      Color(0xFF00e344),
    ];
    Colors.primaries;
    _reportBloc.dispatch(ReportInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _reportBloc,
      listener: (BuildContext context, ReportState state) {
        if (state is Reporting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Đang xử lý...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
      },
      child: BlocBuilder(
          bloc: _reportBloc,
          builder: (BuildContext context, ReportState state) {
            if (state is ReportStart  )
            {
              return Scaffold(
                body: Container(
                  color: Color(0xffE5E5E5),
                  height: 500.0,
                  child: StaggeredGridView.count(
                    crossAxisCount: 1,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        mychart1Items(),
                      ),

                    ],
                    staggeredTiles: [
                      StaggeredTile.extent(4, 300.0),

                    ],
                  ),
                ),
              );
            }
            else if (state is ReportAll)
            {
              sumRe = state.sumRe;
              sumEx = state.sumEx;
              mapEx = state.mapCateSumEx;
              mapRe = state.mapCateSumRe;
              List<CircularSegmentEntry> listEx = new List();
              mapEx.forEach((k, v) => listEx.add(new CircularSegmentEntry(
                  v * 1.0, null,
                  rankKey: k)));
              circularDataEx.add(new CircularStackEntry(listEx));
              List<CircularSegmentEntry> listSegmentEntryEx = circularDataEx[0].entries;

              List<CircularSegmentEntry> listRe = new List();
              mapRe.forEach((k, v) => listRe.add(new CircularSegmentEntry(
                  v * 1.0, null,
                  rankKey: k)));
              circularDataRe.add(new CircularStackEntry(listRe));
              List<CircularSegmentEntry> listSegmentEntryRe = circularDataRe[0].entries;
              Scaffold.of(context)..hideCurrentSnackBar();
              return Scaffold(
                body: Container(
                  color: Color(0xffE5E5E5),
                  height: 500.0,
                  child: StaggeredGridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: mychart1Items(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        myCircularItemsEx(context,listSegmentEntryEx),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        myCircularItemsRe(context,listSegmentEntryRe),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: myTextItems("TỔNG THU",formatMoney(sumRe.toString())),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: myTextItems("TỔNG CHI", formatMoney(sumEx.toString())),
                      ),
                    ],
                    staggeredTiles: [
                      StaggeredTile.extent(4, 300.0),
                      StaggeredTile.extent(4, 400.0),
                      StaggeredTile.extent(4, 400.0),
                      StaggeredTile.extent(4, 120.0),
                      StaggeredTile.extent(4, 120.0),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  ///////////////////////////////////////////////////////////////////////////

  Material myTextItems(String title, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material myCircularItemsEx(BuildContext context,List<CircularSegmentEntry> listSegmentEntryEx) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0,0),
                    child: Text(
                      'DANH MỤC CHI',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
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
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      width: 220,
                      height: 100,
                      child: new ListView.builder(
                          itemCount: mapEx.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: <Widget>[
                                Text("\t"+listSegmentEntryEx[index].rankKey,style:TextStyle(color: colors[index])),
                                Spacer(),
                                Text(formatMoney((listSegmentEntryEx[index].value).toInt().toString()),style:TextStyle(color: colors[index]))
                              ],
                            );
//                            return new Text(:\t'+listSegmentEntry[index].value.toString(),style:TextStyle(color: listSegmentEntry[index].color),);
                          })
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  Material myCircularItemsRe(BuildContext context,List<CircularSegmentEntry> listSegmentEntryRe) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0,0),
                    child: Text(
                      'DANH MỤC THU',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: PieChart(
                      dataMap: mapRe,
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
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      width: 220,
                      height: 100,
                      child: new ListView.builder(
                          itemCount: mapRe.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: <Widget>[
                                Text("\t"+listSegmentEntryRe[index].rankKey,style:TextStyle(color: colors[index])),
                                Spacer(),
                                Text(formatMoney((listSegmentEntryRe[index].value).toInt().toString()),style:TextStyle(color: colors[index]))
                              ],
                            );
//                            return new Text(:\t'+listSegmentEntry[index].value.toString(),style:TextStyle(color: listSegmentEntry[index].color),);
                          })
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }


  Material mychart1Items() {
    final TextStyle valueStyle = Theme.of(context).textTheme.body1;
    return Material(
      color: Colors.white,
      elevation: 0.0,
      borderRadius: BorderRadius.circular(0.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 60,
                    child: DropdownButton<String>(
                      items: listDropDonwMenuItem,
                      value: typeReport,
                      onChanged: (value) {
                        dropDownButtonHandle(value);
                      },
                      hint: Text(
                        "Loại report",
                        style: TextStyle(
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Expanded(
                flex: 4,
                child: new InputDropdown(
                  labelText: "Ngày",
                  valueText: new DateFormat.yMMMd().format(selectedDateFrom),
                  valueStyle: valueStyle,
                  onPressed: () {
                    _selectDateFrom(context);
                  },
                ),
              ),
              const SizedBox(width: 5.0),
              new Expanded(
                flex: 4,
                child: new InputDropdown(
                  labelText: "Đến Ngày",
                  valueText: new DateFormat.yMMMd().format(selectedDateTo),
                  valueStyle: valueStyle,
                  onPressed: () {
                    _selectDateTo(context);
                  },
                ),
              ),
              const SizedBox(width: 5.0),
              new FlatButton(
                textTheme: ButtonTextTheme.primary,
                child: new Text('OK'),
                onPressed: () {
                  _reportBloc.dispatch(ReportPressed(
                      datefrom: selectedDateFrom,
                      dateto: selectedDateTo,
                      type: typeReport));                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dropDownButtonHandle(String value) {
    setState(() {
      typeReport = value;
    });
  }

  Material mychart2Items(String title, String priceVal, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      priceVal,
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDateFrom(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.day,
        initialDate: selectedDateFrom,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateFrom)
      setState(() {
        selectedDateFrom = picked;
      });
  }

  Future<Null> _selectDateTo(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.day,
        initialDate: selectedDateTo,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateTo)
      setState(() {
        selectedDateTo = picked;
      });
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/flutter_logo.png', height: 200),
            ],
          ),
        ));
  }
}
