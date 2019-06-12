import 'package:flutter/material.dart';
import 'page_section.dart';
import 'page_section2.dart';
import 'package:quanly_thuchi/edit_revenue_expenditure/edit_revenue_expendture.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RevenueExpenditurePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RevenueExpediturePage();
  }
}

class _RevenueExpediturePage extends State<RevenueExpenditurePage> {
  PageBloc _pageBloc;

  List<Tab> list = new List(10);
  List<PageSection> listPage = new List(10);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageBloc = new PageBloc();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date4 = DateTime.now();
    //3 ngay sau
    DateTime date1 = new DateTime(date4.year, date4.month, date4.day + 1);
    DateTime date2 = new DateTime(date4.year, date4.month, date4.day + 1);
    DateTime date3 = new DateTime(date4.year, date4.month, date4.day + 1);
    //7 ngay truoc
    DateTime date5 = new DateTime(date4.year, date4.month, date4.day - 1);
    DateTime date6 = new DateTime(date4.year, date4.month, date4.day - 2);
    DateTime date7 = new DateTime(date4.year, date4.month, date4.day - 3);
    DateTime date8 = new DateTime(date4.year, date4.month, date4.day - 4);
    DateTime date9 = new DateTime(date4.year, date4.month, date4.day - 5);
    DateTime date10 = new DateTime(date4.year, date4.month, date4.day - 6);


    var format = new DateFormat("yyyy-MM-dd");
    String strDate1 = format.format(date1);
    String strDate2 = format.format(date2);
    String strDate3 = format.format(date3);
    String strDate4 = format.format(date4);
    String strDate5 = format.format(date5);
    String strDate6 = format.format(date6);
    String strDate7= format.format(date7);
    String strDate8 = format.format(date8);
    String strDate9 = format.format(date9);
    String strDate10 = format.format(date10);

    list[0] = Tab(child: Text(strDate10));
    list[1] = Tab(child: Text(strDate9));
    list[2] = Tab(child: Text(strDate8));
    list[3] = Tab(child: Text(strDate7));
    list[4] = Tab(child: Text(strDate6));
    list[5] = Tab(child: Text(strDate5));
    list[6] = Tab(child: Text(strDate4));
    list[7] = Tab(child: Text(strDate3));
    list[8] = Tab(child: Text(strDate2));
    list[9] = Tab(child: Text(strDate1));
    listPage[0] = PageSection(dateTime: strDate10,);
    listPage[1] = PageSection(dateTime: strDate9,);
    listPage[2] = PageSection(dateTime: strDate8,);
    listPage[3] = PageSection(dateTime: strDate7,);
    listPage[4] = PageSection(dateTime: strDate6,);
    listPage[5] = PageSection(dateTime: strDate5,);
    listPage[6] = PageSection(dateTime: strDate4,);
    listPage[7] = PageSection(dateTime: strDate3,);
    listPage[8] = PageSection(dateTime: strDate2,);
    listPage[9] = PageSection(dateTime: strDate1,);

    return BlocProvider(
        bloc: _pageBloc,
        child: DefaultTabController(
            initialIndex: 6,
            length: list.length,
            child: Scaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(50.0),
                    // here the desired height
                    child: AppBar(
                      bottom: PreferredSize(
                          child: TabBar(
                              isScrollable: true,
                              unselectedLabelColor:
                              Colors.white.withOpacity(0.3),
                              indicatorColor: Colors.white,
                              tabs: list),
                          preferredSize: Size.fromHeight(30.0)),
                    )),
                body: Stack(
                  children: <Widget>[
                    TabBarView(
                      children: listPage,
                    ),
                    Padding(
                        padding: EdgeInsets.all(30),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditRevenueExpendture()),
                              );
                            },
                            child: Icon(
                              Icons.add,
                            ),
                            backgroundColor: Colors.pink,
                          ),
                        ))
                  ],
                ))));
  }
}
//
