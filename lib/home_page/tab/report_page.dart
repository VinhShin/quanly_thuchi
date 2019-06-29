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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quanly_thuchi/report/cate_chart_circle.dart';
import 'package:quanly_thuchi/report/cate_report_item.dart';
import 'package:quanly_thuchi/report/cate_menu_report.dart';
import 'package:quanly_thuchi/model/transaction_section.dart';
import 'package:quanly_thuchi/model/transaction.dart';
import 'package:quanly_thuchi/model/transaction_header.dart';
import 'package:quanly_thuchi/constant.dart';
import 'package:quanly_thuchi/report/detail_transaction.dart';
import 'package:quanly_thuchi/category/category.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: MyHomePage(),
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
  List<Transaction> listTransactionRE = new List();
  List<Transaction> listTransactionEX = new List();

  /////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    _reportBloc = new ReportBloc();
    listDropDonwMenuItem
        .add(new DropdownMenuItem(value: "d", child: new Text("Trong ngày")));
    listDropDonwMenuItem
        .add(new DropdownMenuItem(value: "w", child: new Text("Trong tuần")));
    listDropDonwMenuItem
        .add(new DropdownMenuItem(value: "m", child: new Text("Trong tháng")));
    listDropDonwMenuItem
        .add(new DropdownMenuItem(value: "y", child: new Text("Trong năm")));
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
      listener: (BuildContext context, ReportState state) {},
      child: BlocBuilder(
          bloc: _reportBloc,
          builder: (BuildContext context, ReportState state) {
            if (state is ReportStart) {
              return Scaffold(
                body: Container(
                  child: CateMenuReport(listDropDonwMenuItem, typeReport,
                      selectedDateFrom, selectedDateTo, _reportBloc),
                ),
              );
            } else if (state is ReportAll) {
              circularDataEx.clear();
              circularDataRe.clear();
              sumRe = state.sumRe;
              sumEx = state.sumEx;
              mapEx = state.mapCateSumEx;
              mapRe = state.mapCateSumRe;
              listTransactionEX = state.listExpendture;
              listTransactionRE = state.listRevenue;
//              typeReport = state.reportType;
              List<CircularSegmentEntry> listEx = new List();
              mapEx.forEach((k, v) => listEx
                  .add(new CircularSegmentEntry(v * 1.0, null, rankKey: k)));
              circularDataEx.add(new CircularStackEntry(listEx));
              List<CircularSegmentEntry> listSegmentEntryEx =
                  circularDataEx[0].entries;

              List<CircularSegmentEntry> listRe = new List();
              mapRe.forEach((k, v) => listRe
                  .add(new CircularSegmentEntry(v * 1.0, null, rankKey: k)));
              circularDataRe.add(new CircularStackEntry(listRe));
              List<CircularSegmentEntry> listSegmentEntryRe =
                  circularDataRe[0].entries;
              Scaffold.of(context)..hideCurrentSnackBar();
              final TextStyle valueStyle = Theme.of(context).textTheme.body1;

              return Scaffold(
                  body: Container(
                      child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
//                            CateMenuReport(
//                                  listDropDonwMenuItem,
//                                  typeReport,
//                                  selectedDateFrom,
//                                  selectedDateTo,
//                                  _reportBloc),
                    Column(
                      children: <Widget>[
                        Container(
                          height: 60,
                          child: DropdownButton<String>(
                            isExpanded: true,
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
                        typeReport == "d2d"
                            ? InputDropdown(
                                labelText: "Từ Ngày",
                                valueText: new DateFormat.yMMMd()
                                    .format(selectedDateFrom),
                                valueStyle: valueStyle,
                                onPressed: () {
                                  _selectDateFrom(context);
                                },
                              )
                            : new Container(),
                        const SizedBox(width: 5.0),
                        typeReport == "d2d"
                            ? InputDropdown(
                                labelText: "Đến Ngày",
                                valueText: new DateFormat.yMMMd()
                                    .format(selectedDateTo),
                                valueStyle: valueStyle,
                                onPressed: () {
                                  _selectDateTo(context);
                                },
                              )
                            : new Container(),
                        const SizedBox(width: 5.0),
                        new FlatButton(
                          textTheme: ButtonTextTheme.primary,
                          child: Text('OK'),
                          onPressed: () {
                            _reportBloc.dispatch(ReportPressed(
                                datefrom: selectedDateFrom,
                                dateto: selectedDateTo,
                                type: typeReport));
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: 5,
                      color: Colors.grey,
                    ),
                    Container(
                        height: 400,
                        child: CateChartCircle(context, mapEx, colors,
                            listSegmentEntryEx, "DANH MỤC CHI")),
                    Container(
                      height: 5,
                      color: Colors.grey,
                    ),
                    Container(
                        height: 400,
                        child: CateChartCircle(context, mapRe, colors,
                            listSegmentEntryRe, "DANH MỤC THU")),
                    Container(
                      height: 5,
                      color: Colors.grey,
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailTransaction(this.listTransactionRE)),
                        );
                      },
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CateReportItem(
                            "TỔNG THU", formatMoney(sumRe.toString())),
                      ),
                    ),

                    Container(
                      height: 5,
                      color: Colors.grey,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailTransaction(this.listTransactionEX)),
                        );
                      },
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CateReportItem(
                            "TỔNG CHI", formatMoney(sumEx.toString())),
                      ),
                    ),
                    Container(
                      height: 5,
                      color: Colors.grey,
                    ),
                  ],
                ),
              )));
            } else {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitCircle(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                    Text(
                      "Đang tải dữ liệu...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              );
            }
          }),
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

  void dropDownButtonHandle(String value) {
    setState(() {
      typeReport = value;
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
