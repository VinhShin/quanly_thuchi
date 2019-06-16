import 'package:flutter/material.dart';
import 'package:quanly_thuchi/home_page/tab/report_page.dart';
import 'package:quanly_thuchi/home_page/tab/revenue_expenditure_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quanly_thuchi/main.dart';
import 'package:quanly_thuchi/user/user_home.dart';
class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Thu Chi", new Icon(FontAwesomeIcons.coins).icon),
    new DrawerItem("Báo cáo", new Icon(FontAwesomeIcons.chartLine).icon),
    new DrawerItem("Quản lý tài khoản", new Icon(FontAwesomeIcons.user).icon),
    new DrawerItem("Đăng xuất", new Icon(FontAwesomeIcons.signOutAlt).icon)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {

      switch (pos) {
        case 0:
          return new RevenueExpenditurePage();
        case 1:
          return new ReportPage();
        case 2:
          return new UserHome();
        default:
          return new Text("Error");
    }

  }

  _onSelectItem(int index) {
    if(index == 3){
      Navigator.of(context)
          .pushReplacementNamed("logout");
    } else {
      setState(() => _selectedDrawerIndex = index);
      Navigator.of(context).pop(); // close the drawer
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }
    return Scaffold(
          appBar: new AppBar(
            // here we display the title corresponding to the fragment
            // you can instead choose to have a static title
            title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
          ),
          drawer: new Drawer(
            child: new Column(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                    accountName: new Text("Tên nhân viên"), accountEmail: null),
                new Column(children: drawerOptions)
              ],
            ),
          ),
          body: _getDrawerItemWidget(_selectedDrawerIndex),
        );
  }
}
