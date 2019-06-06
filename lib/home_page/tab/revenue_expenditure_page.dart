import 'package:flutter/material.dart';
import 'page_section.dart';

class RevenueExpenditurePage extends StatelessWidget {
  final controller = PageController(initialPage: 2);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        SizedBox(
          height:50,
        child:ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemCount: 50,
            itemBuilder: (context, position) {
              return Container(
                  margin: EdgeInsets.all(5),
                  child: Card(
                    child: Center(
                      child: Text(
                        position.toString() + "/6/19", style: TextStyle(fontSize: 22.0),),
                    ),
                  ));
            }),

    ),
        Expanded(
            child: PageView(
          controller: controller,
          children: <Widget>[
            PageSection(),
            PageSection(),
          ],
        ))
      ],
    );
  }
}
//