import 'package:flutter/material.dart';
import 'page_section.dart';
import 'package:quanly_thuchi/edit_revenue_expenditure/edit_revenue_expendture.dart';

class RevenueExpenditurePage extends StatelessWidget {

  List<Tab> list = new List(9);
  List<PageSection> listPage = new List(9);
  @override
  Widget build(BuildContext context) {
//    _tabController = new TabController(length: 6, vsync: TickerProvider, initialIndex: 3);
    list[0] = Tab(child: Text("06-01-19"));
    list[1] = Tab(child: Text("05-01-19"));
    list[2] = Tab(child: Text("04-01-19"));
    list[3] = Tab(child: Text("03-01-19"));
    list[4] = Tab(child: Text("02-01-19"));
    list[5] = Tab(child: Text("01-01-19"));
    list[6] = Tab(child: Text("01-01-19"));
    list[7] = Tab(child: Text("01-01-19"));
    list[8] = Tab(child: Text("01-01-19"));
    listPage[0] = PageSection();
    listPage[1] = PageSection();
    listPage[2] = PageSection();
    listPage[3] = PageSection();
    listPage[4] = PageSection();
    listPage[5] = PageSection();
    listPage[6] = PageSection();
    listPage[7] = PageSection();
    listPage[8] = PageSection();
    return DefaultTabController(
      initialIndex: 3,
      length: 9,
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0), // here the desired height
              child: AppBar(
                bottom: PreferredSize(
                    child: TabBar(
                        isScrollable: true,
                        unselectedLabelColor: Colors.white.withOpacity(0.3),
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
                  child:Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditRevenueExpendture()),
                        );
                      },
                      child: Icon(Icons.add,),
                      backgroundColor: Colors.pink,
                    ),
                  )
              )
              

            ],
          )
      )
    );
  }

}
//
