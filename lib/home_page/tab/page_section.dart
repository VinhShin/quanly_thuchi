import 'package:flutter/material.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_state.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_event.dart';
import 'package:quanly_thuchi/model/transaction.dart';
import 'package:quanly_thuchi/model/transaction_section.dart';
import 'package:quanly_thuchi/constant.dart';
import 'package:quanly_thuchi/edit_revenue_expenditure/edit_revenue_expendture.dart';
import 'package:quanly_thuchi/common_func.dart';

class PageSection extends StatefulWidget {
  String dateTime;

  PageSection({@required this.dateTime});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PageSection(dateTime: dateTime);
  }
}

class _PageSection extends State<PageSection> {
  String dateTime;
  PageBloc _pageBloc;
  TransactionSection section;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  _PageSection({@required this.dateTime});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageBloc = BlocProvider.of<PageBloc>(context);
    _pageBloc.dispatch(PageLoadData(dateTime));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(PageSection oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _pageBloc.dispatch(PageLoadData(dateTime));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          _pageBloc.dispatch(PageLoadData(this.dateTime));
          return _handleRefresh();
        },
        child: BlocListener(
            bloc: _pageBloc,
            listener: (BuildContext context, PageState pageState) {},
            child: BlocBuilder(
                bloc: _pageBloc,
                builder: (BuildContext context, PageState pageState) {
                  if (pageState is PageLoadedData &&
                      pageState.section != null) {
                    if (pageState.dateTime == this.dateTime) {
                      this.section = pageState.section;
                    }
                    if (this.section != null) {
                      return Padding(
                          padding: EdgeInsets.all(20),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
//                        TextKeyValue("Tiền đầu ngày:", "200.000"),
                              TextKeyValue(
                                  "Tiền thu:",
                                  formatMoney(this
                                      .section
                                      .transactionHeader
                                      .revenue
                                      .toString())),
                              TextKeyValue(
                                  "Tiền chi:",
                                  formatMoney(this
                                      .section
                                      .transactionHeader
                                      .expendture
                                      .toString())),
                              TextKeyValue(
                                  "Tổng:",
                                  formatMoney(this
                                      .section
                                      .transactionHeader
                                      .total
                                      .toString())),
//                        TextKeyValue("Tiền cuối ngày:", "290.000"),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: CustomPaint(
                                  size: Size(
                                      MediaQuery.of(context).size.width, 1),
                                  painter: Drawhorizontalline(),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: ListView.builder(
                                  itemCount: this.section.transactions.length,
                                  itemBuilder: (context, position) {
                                    return ItemRow(
                                        transaction:
                                            this.section.transactions[position],
                                        pageBloc: _pageBloc);
                                  },
                                ),
                              )
                            ],
                          ));
                    }
                  }
                  return Padding(
                      padding: EdgeInsets.all(20),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
//                      TextKeyValue("Tiền đầu ngày:", "200.000"),
                          TextKeyValue("Tiền thu:", "0"),
                          TextKeyValue("Tiền chi:", "0"),
                          TextKeyValue("Tổng:", "0"),
//                      TextKeyValue("Tiền cuối ngày:", "290.000")
                        ],
                      ));
                })));
  }

  Future<bool> _handleRefresh() async {
    return true;
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

class TextKeyValue extends StatelessWidget {
  final textStyle = TextStyle(
    fontSize: 21,
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
                    Text(
                      transaction.cateId ?? "",
                      style: TextStyle(
                          color: transaction.type == REVENUE_TYPE
                              ? Colors.green
                              : Colors.red,
                          fontSize: 22.0),
                    ),
                    Spacer(),
                    Text(
                      formatMoney(transaction.money.toString()),
                      style: TextStyle(
                          color: transaction.type == REVENUE_TYPE
                              ? Colors.green
                              : Colors.red,
                          fontSize: 22.0),
                    )
                  ],
                )),
          ),
        ));
  }
}
