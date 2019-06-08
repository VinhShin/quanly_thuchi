import 'package:flutter/material.dart';
import 'package:quanly_thuchi/base_widget/text_base.dart';
import 'package:quanly_thuchi/base_widget/edit_base.dart';
import 'package:intl/intl.dart';

class EditRevenueExpendture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text("Thêm thu chi"),
      ),
      body: EditPage(),
    );
  }
}

class EditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditPage();
}

class _EditPage extends State<EditPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List(5);
    items[0] =
        (new DropdownMenuItem(value: "Bán hàng", child: new Text("Bán hàng")));
    items[1] =
        (new DropdownMenuItem(value: "Thu nợ", child: new Text("Thu nợ")));
    items[2] =
        (new DropdownMenuItem(value: "Vay nợ", child: new Text("Vay nợ")));
    items[3] =
        (new DropdownMenuItem(value: "Thu khác", child: new Text("Thu khác")));
    items[4] = (new DropdownMenuItem(
        value: "Điều chỉnh", child: new Text("Điều chỉnh")));
    return items;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.day,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
//      if (picked != null && picked != selectedTime) selectTime(picked);
  }

//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Text("hshs");
//  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.body1;
    return SingleChildScrollView(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextBase("Số tiền"),
          EditBase("200.000"),
          TextBase("Danh mục "),
          Container(
            margin: EdgeInsets.only(left: 10),
            height: 60,
            child: DropdownButton<String>(
              items: getDropDownMenuItems(),
              onChanged: (value) {
                print("value: $value");
              },
              hint: Text(
                "Chọn danh mục",
                style: TextStyle(
                  color: Colors.pink,
                ),
              ),
            ),
          ),
          TextBase("Thời gian"),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Expanded(
                  flex: 4,
                  child: new _InputDropdown(
                    labelText: "Ngày",
                    valueText: new DateFormat.yMMMd().format(selectedDate),
                    valueStyle: valueStyle,
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
                const SizedBox(width: 12.0),
                new Expanded(
                  flex: 3,
                  child: new _InputDropdown(
                    labelText: "Giờ",
                    valueText: selectedTime.format(context),
                    valueStyle: valueStyle,
                    onPressed: () {
                      _selectTime(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          TextBase("Ghi chú"),
          EditBase("", true),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 50,
            alignment: Alignment.center,
            child:  RaisedButton(
              color: Colors.blue,
                onPressed: () {},
                child: Container(
                  width: 100,
                  height: 40,
                  child: Center(
                    child: Text(
                        'Thêm',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white)
                    ),
                  )
                )
            ),
          )


        ],
      ),
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
