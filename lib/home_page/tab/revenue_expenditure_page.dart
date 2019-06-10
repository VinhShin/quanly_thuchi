import 'package:flutter/material.dart';
import 'page_section.dart';
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

  List<Tab> list = new List(9);
  List<PageSection> listPage = new List(9);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageBloc = new PageBloc();
  }

  @override
  Widget build(BuildContext context) {
//    _tabController = new TabController(length: 6, vsync: TickerProvider, initialIndex: 3);
    DateTime dateTime = DateTime.now();
    var format = new DateFormat("yyyy-MM-dd");
    String today = format.format(dateTime);

    list[0] = Tab(child: Text(today));
    list[1] = Tab(child: Text(today));
    list[2] = Tab(child: Text(today));
    list[3] = Tab(child: Text(today));
    list[4] = Tab(child: Text(today));
    list[5] = Tab(child: Text(today));
    list[6] = Tab(child: Text(today));
    list[7] = Tab(child: Text(today));
    list[8] = Tab(child: Text(today));
    listPage[0] = PageSection(dateTime: today,);
    listPage[1] = PageSection(dateTime: today,);
    listPage[2] = PageSection(dateTime: today,);
    listPage[3] = PageSection(dateTime: today,);
    listPage[4] = PageSection(dateTime: today,);
    listPage[5] = PageSection(dateTime: today,);
    listPage[6] = PageSection(dateTime: today,);
    listPage[7] = PageSection(dateTime: today,);
    listPage[8] = PageSection(dateTime: today,);

    return BlocProvider(
        bloc: _pageBloc,
        child: DefaultTabController(
            initialIndex: 3,
            length: 9,
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
