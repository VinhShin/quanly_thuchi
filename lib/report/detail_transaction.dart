import 'package:flutter/material.dart';
import 'package:quanly_thuchi/model/transaction.dart';
import 'package:quanly_thuchi/constant.dart';
import 'package:quanly_thuchi/common_func.dart';

class DetailTransaction extends StatefulWidget {

  List<Transaction> transaction;

  DetailTransaction(this.transaction);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _detailTransaction(this.transaction);
  }
}

class _detailTransaction extends State<DetailTransaction> {
  List<Transaction> transaction;

  _detailTransaction(this.transaction);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text("Chi tiết thu chi"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: this.transaction.length,
        itemBuilder: (context, position) {
          return ItemRow(transaction: this.transaction[position]);
        },
      ),
    );
  }
}

class ItemRow extends StatelessWidget {
  final Transaction transaction;

  const ItemRow({Key key, @required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        child: GestureDetector(
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
