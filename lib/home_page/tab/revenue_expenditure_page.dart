import 'package:flutter/material.dart';
import 'page_section.dart';
import 'package:thuchi/edit_revenue_expenditure/edit_revenue_expendture.dart';
import 'package:thuchi/home_page/tab/bloc/page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:thuchi/home_page/tab/bloc/page_event.dart';
import 'package:thuchi/home_page/tab/option_page.dart';

class RevenueExpenditurePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RevenueExpediturePage();
  }
}

class _RevenueExpediturePage extends State<RevenueExpenditurePage> {
  PageBloc _pageBloc;

  List<Tab> list = new List(2);
  List<Widget> listPage = new List(2);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageBloc = new PageBloc();
  }


  @override
  Widget build(BuildContext context) {

    DateTime date4 = DateTime.now();

    var format = new DateFormat("yyyy-MM-dd");
    String strDate4 = format.format(date4);
    list[0] = Tab(child: Text("Hôm nay"));
    list[1] = Tab(child: Text("Tùy chọn"));
    listPage[0] = PageSection(dateTime: strDate4,);
    listPage[1] = OptionPage();
    _passAddScreen()async{
      var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditRevenueExpendture()),
      );
      if(result){
        _pageBloc.dispatch(PageLoadData(strDate4));
      }
    }

    return BlocProvider(
        bloc: _pageBloc,
        child: DefaultTabController(
            initialIndex: 0,
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
                              _passAddScreen();
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
