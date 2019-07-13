import 'package:flutter/material.dart';
import 'package:thuchi/edit_revenue_expenditure/input_down.dart';
import 'package:intl/intl.dart';
import 'package:thuchi/report/report_bloc/report_event.dart';
import 'package:thuchi/report/report_bloc/report_bloc.dart';

class CateMenuReport extends StatefulWidget {
  List<DropdownMenuItem<String>> listDropDonwMenuItem;
  String typeReport = "d";
  DateTime selectedDateFrom;
  DateTime selectedDateTo;
  ReportBloc _reportBloc;

  CateMenuReport(this.listDropDonwMenuItem, this.typeReport,
      this.selectedDateFrom, this.selectedDateTo, this._reportBloc);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _cateMenuReport(this.listDropDonwMenuItem, this.typeReport,
        this.selectedDateFrom, this.selectedDateTo, this._reportBloc);
  }
}

class _cateMenuReport extends State<CateMenuReport> {
  List<DropdownMenuItem<String>> listDropDonwMenuItem;
  String typeReport = "d";
  DateTime selectedDateFrom;
  DateTime selectedDateTo;
  ReportBloc _reportBloc;

  _cateMenuReport(this.listDropDonwMenuItem, this.typeReport,
      this.selectedDateFrom, this.selectedDateTo, this._reportBloc);

  void dropDownButtonHandle(String value) {
    setState(() {
      typeReport = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.body1;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: 300,
        child: Column(
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
              valueText: new DateFormat.yMMMd().format(selectedDateFrom),
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
              valueText: new DateFormat.yMMMd().format(selectedDateTo),
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
      )

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
