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
  int tongChi;
  int tongThu;

  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDateTo = DateTime.now();
  List<DropdownMenuItem<String>> listDropDonwMenuItem = new List();
  String typeReport = "d";
  List<CircularStackEntry> circularData = <CircularStackEntry>[];

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
                          mychart1Items(
                              'Setting Report', "421.3M", "+12.9% of target"),
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
              tongThu = state.tongThu;
              tongChi = state.tongChi;
              Map<String, int> map = state.mapCateSum;
              List<CircularSegmentEntry> list = new List();
              List colors = Colors.primaries;
              Random random = new Random();
              map.forEach((k, v) => list.add(new CircularSegmentEntry(
                  v * 1.0, colors[random.nextInt(colors.length)],
                  rankKey: k)));
              CircularStackEntry circularStackEntry = new CircularStackEntry(list);
              circularData.add(circularStackEntry);
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
                        child: mychart1Items(
                            'Setting Report', "421.3M", "+12.9% of target"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        myCircularItems("Quarterly Profits"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: myTextItems("TỔNG THU", tongThu.toString()),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: myTextItems("TỔNG CHI", tongChi.toString()),
                      ),
                    ],
                    staggeredTiles: [
                      StaggeredTile.extent(4, 300.0),
                      StaggeredTile.extent(4, 350.0),
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

  Material myCircularItems(
      String title) {
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
                      'subtitle',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AnimatedCircularChart(
                      size: const Size(300.0, 100.0),
                      initialChartData: circularData,
                      chartType: CircularChartType.Pie,
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

  Material mychart1Items(String title, String priceVal, String subtitle) {
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
