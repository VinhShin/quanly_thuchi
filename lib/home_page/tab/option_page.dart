import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quanly_thuchi/category/bloc/cate_bloc.dart';
import 'package:quanly_thuchi/edit_revenue_expenditure/edit_revenue_expendture.dart';
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
import 'bloc/page_state.dart';
import 'bloc/page_event.dart';
import 'bloc/page_bloc.dart';
import 'package:quanly_thuchi/model/transaction_section.dart';

class OptionPage extends StatelessWidget {
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
  PageBloc _pageBloc;
  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDateTo = DateTime.now();
  String typeReport = "d2d";
  bool isVisible = true;
  String textState = "Ẩn";
  TransactionSection section;

  @override
  void initState() {
    _pageBloc = BlocProvider.of<PageBloc>(context);
    section = _pageBloc.getTemp("");
    if (section.transactions.length == 0) {
      _pageBloc.dispatch(OptionStart());
    }
    super.initState();
  }

  changeState(){
    isVisible = !isVisible;
    if(isVisible){
      textState = "Ẩn";
    } else{
      textState = "Hiện";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _pageBloc,
      listener: (BuildContext context, PageState state) {},
      child: BlocBuilder(
          bloc: _pageBloc,
          builder: (BuildContext context, PageState state) {
            if (state is PageLoadingOption) {
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
            } else if (state is PageLoadOption) {
              section = state.section;
            }
            Scaffold.of(context)..hideCurrentSnackBar();
            final TextStyle valueStyle = Theme.of(context).textTheme.body1;

            return Scaffold(
                body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: isVisible,
                    child: InputDropdown(
                      labelText: "Từ Ngày",
                      valueText:
                          new DateFormat.yMMMd().format(selectedDateFrom),
                      valueStyle: valueStyle,
                      onPressed: () {
                        _selectDateFrom(context);
                      },
                    ),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: InputDropdown(
                      labelText: "Đến Ngày",
                      valueText: new DateFormat.yMMMd().format(selectedDateTo),
                      valueStyle: valueStyle,
                      onPressed: () {
                        _selectDateTo(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(""),
                      Visibility(
                        visible: isVisible,
                        child: new FlatButton(
                          padding: EdgeInsets.only(left:40),
                          textTheme: ButtonTextTheme.primary,
                          child: Text('OK'),
                          onPressed: () {
                            _pageBloc.dispatch(
                                OptionLoadData(selectedDateFrom, selectedDateTo));
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  changeState();
                                });
                              },
                              child:
                                  Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.only(left: 10, top: 20),
                                    height: 40,
                                    width: 40,
                                    child:Text(textState,style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold) ,
                                  )

                            ),
                          ),
                        ),
                    ],
                  ),
                  TextKeyValue(
                      "Tiền thu:",
                      formatMoney(
                          this.section.transactionHeader.revenue.toString())),
                  TextKeyValue(
                      "Tiền chi:",
                      formatMoney(this
                          .section
                          .transactionHeader
                          .expendture
                          .toString())),
                  TextKeyValue(
                      "Tổng:",
                      formatMoney(
                          this.section.transactionHeader.total.toString())),
                  Flexible(
                    child: ListView.builder(
                      itemCount: this.section.transactions.length,
                      itemBuilder: (context, position) {
                        return ItemRow(
                            transaction: this.section.transactions[position],
                            pageBloc: _pageBloc);
                      },
                    ),
                  ),
                ],
              ),
            ));
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

class ItemRow extends StatelessWidget {
  final Transaction transaction;
  final PageBloc pageBloc;

  const ItemRow({Key key, @required this.transaction, this.pageBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditRevenueExpendture(transaction: transaction)));
            if (result != null) {
              pageBloc.dispatch(PageLoadData(transaction.date));
            }
          },
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Text(
                          transaction.cateName ?? "",
                          style: TextStyle(
                              color: transaction.type == REVENUE_TYPE
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 18.0),
                        )),
                    Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            transaction.subUserId == '2'
                                ? ""
                                : transaction.subUserId,
                            style:
                                TextStyle(color: Colors.blue, fontSize: 18.0),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            formatMoney(transaction.money.toString()),
                            style: TextStyle(
                                color: transaction.type == REVENUE_TYPE
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 18.0),
                          ),
                        ))
                  ],
                )),
          ),
        ));
  }
}

class TextKeyValue extends StatelessWidget {
  final textStyle = TextStyle(
    fontSize: 18,
  );
  String title;
  String value;

  TextKeyValue(title, value) {
    this.title = title;
    this.value = value;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        margin: EdgeInsets.only(top: 10),
        child: new Row(
          children: <Widget>[
            Text(title, textAlign: TextAlign.left, style: textStyle),
            Spacer(),
            Text(value, textAlign: TextAlign.left, style: textStyle),
          ],
        ));
  }
}
