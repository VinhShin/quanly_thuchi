import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanly_thuchi/base_widget/text_base.dart';
import 'package:quanly_thuchi/base_widget/edit_base.dart';
import 'package:intl/intl.dart';
import 'package:quanly_thuchi/model/transaction.dart';
import 'package:quanly_thuchi/edit_revenue_expenditure/bloc/edit_bloc.dart';
import 'package:quanly_thuchi/edit_revenue_expenditure/bloc/edit_event.dart';
import 'package:quanly_thuchi/edit_revenue_expenditure/bloc/edit_state.dart';
import 'package:quanly_thuchi/constant.dart';
import 'package:quanly_thuchi/edit_revenue_expenditure/input_down.dart';
import 'package:quanly_thuchi/base_widget/edit_money_base.dart';
import 'package:quanly_thuchi/common_func.dart';
import 'package:quanly_thuchi/category/category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quanly_thuchi/model/category_model.dart';

class EditRevenueExpendture extends StatelessWidget {
  Transaction transaction = null;

  EditRevenueExpendture({this.transaction});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text(transaction == null ? "Thêm thu chi" : "Sửa thu chi"),
      ),
      body: EditPage(transaction),
    );
  }
}

class EditPage extends StatefulWidget {
  Transaction transaction;

  EditPage(this.transaction);

  @override
  State<StatefulWidget> createState() => _EditPage(transaction);
}

class _EditPage extends State<EditPage> {
  Transaction transaction;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController moneyInput = new TextEditingController();
  TextEditingController noteInput = new TextEditingController();
  EditBloc _editBloc;
  int _radioValue1 = REVENUE_TYPE;
  String _category;
  List<CategoryModel> _listCate;
  bool isOnClick = false;
  bool isShowEditCategory = true;


  List<DropdownMenuItem<String>> listDropDonwMenuItem = new List();

  _EditPage(this.transaction);

  void dropDownButtonHandle(String value) {
    setState(() {
      _category = value;
    });
  }

  @override
  void initState() {
    _editBloc = new EditBloc();
    _editBloc.dispatch(LoadCategory());
    if (transaction != null) {
      moneyInput.text = formatMoney(transaction.money.toString());
      noteInput.text = transaction.note;
      _category = transaction.cateName;
      _radioValue1 = transaction.type;
      selectedDate = DateTime.parse(transaction.date + " 00:00:00.00");
      List<String> times = transaction.time.split(" ");

      String time = times[0];
      String timeType = times.length > 1 ? times[1] : "";
      int hour = int.parse(time.split(":")[0]);
      String minute = time.split(":")[1];
      if (timeType == "PM") {
        hour += 12;
      }
      selectedTime = TimeOfDay(hour: hour, minute: int.parse(minute));
    }
    _category = "Chọn danh mục";
    listDropDonwMenuItem.add(new DropdownMenuItem(
        value: "Chọn danh mục", child: new Text("Chọn danh mục")));

    SharedPreferences.getInstance().then((prefs) {
      final String subUserName = prefs.getString(SUB_USER_NAME);
      setState(() {
        isShowEditCategory = subUserName == SUB_USER_NAME_EMPTY;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.body1;
    return BlocListener(
      bloc: _editBloc,
      listener: (BuildContext context, EditState editState) {
        if (editState.currentStep == STEP_LOADING) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Đang xử lý...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        } else {
          Scaffold.of(context)..hideCurrentSnackBar();
          if (editState.currentStep == CONNECT_FAIL) {
            alertNotify(this.context, "Tác vụ thất bại",
                "Bạn cần kết nối internet để thực hiện tác vụ này");
          } else if (editState.currentStep == STEP_INSERT && editState.status) {
            Navigator.pop(context, true);
          } else if (editState.currentStep == STEP_DELETE && editState.status) {
            Navigator.pop(context, true);
          } else if (editState.currentStep == STEP_UPDATE && editState.status) {
            Navigator.pop(context, true);
          }
        }
      },
      child: BlocBuilder(
          bloc: _editBloc,
          builder: (BuildContext context, EditState edistate) {
            if (edistate is EditAllCategory) {
              this._listCate = edistate.list;
              listDropDonwMenuItem = new List(edistate.list.length);
              for (int i = 0; i < edistate.list.length; i++) {
                listDropDonwMenuItem[i] = new DropdownMenuItem(
                    value: edistate.list[i].name,
                    child: new Text(edistate.list[i].name));
              }
              if (edistate.list.length > 0) {
                _category = edistate.list[0].name;
              }
              _editBloc.dispatch(EditEventEmpty());
            }
            return Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
//                        Container(
//                          child: Row(children: <Widget>[
//                            Container(child: TextBase("Loại")),
//                            Container(
//                              margin: EdgeInsets.only(top: 10),
//                              child: Row(children: createRadioListUsers()),
//                            )
//                          ]),
//                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    TextBase("Danh mục"),
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 60,
                                      child: DropdownButton<String>(
                                        items: listDropDonwMenuItem,
                                        value: _category,
                                        onChanged: (value) {
                                          dropDownButtonHandle(value);
                                        },
                                        hint: Text(
                                          "Chọn danh mục",
                                          style: TextStyle(
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: isShowEditCategory,
                                      child: GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20),
                                          height: 60,
                                          child: GestureDetector(
                                            onTap: passEditCategory,
                                            child: Icon(Icons.edit),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextBase("Số tiền"),
                        EditMoneyBase(
                          "200.000",
                          controller: this.moneyInput,
                          isMoney: true,
                        ),
                        TextBase("Thời gian"),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Expanded(
                                flex: 4,
                                child: new InputDropdown(
                                  labelText: "Ngày",
                                  valueText: new DateFormat.yMMMd()
                                      .format(selectedDate),
                                  valueStyle: valueStyle,
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              new Expanded(
                                flex: 3,
                                child: new InputDropdown(
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
                        EditBase("",
                            isMultiline: true, controller: this.noteInput),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  height: 50,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: transaction != null
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.center,
                    children: <Widget>[
                      Visibility(
                        visible: transaction != null,
                        child: RaisedButton(
                            color: Colors.blue,
                            onPressed: () {
                              _showDialog(_editBloc);
                            },
                            child: Container(
                                width: 100,
                                height: 40,
                                child: Center(
                                  child: Text("Xoá",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ))),
                      ),
                      RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            if (!isOnClick) {
                              Transaction transac = getReExData();
                              if (transac != null) {
                                _editBloc.dispatch(transaction == null
                                    ? InsertData(reExData: transac)
                                    : Update(reExData: transac));
                              } else {
                                isOnClick = false;
                              }
                            }
                          },
                          child: Container(
                              width: 100,
                              height: 40,
                              child: Center(
                                child: Text(
                                    transaction == null ? 'Thêm' : "Cập nhật",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              )))
                    ],
                  ),
                )
              ],
            );
          }),
    );
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
//    if(transaction == null) {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Transaction getReExData() {
// Try reading data from the counter key. If it does not exist, return 0.
    var dateFormat = new DateFormat('yyyy-MM-dd');
    String date = dateFormat.format(selectedDate);

    String money = moneyInput.text;
    money = money.replaceAll('.', '');
    if (money.length == 0) {
      alertNotify(context, "Thông báo", "Số tiền không được để trống");
    } else {
      int type = getTypeCategory();
      Transaction newTransaction = new Transaction(
          getTypeCategory(),
          int.parse(money),
          date,
          selectedTime.format(context),
          noteInput.text,
          _category,
          '');
      if (transaction != null) {
        newTransaction.setId = transaction.id;
        newTransaction.setSubUserId = transaction.subUserId;
      }
      return newTransaction;
    }
    return null;
  }

  int getTypeCategory(){
    int typeCategory = 0;
    _listCate.forEach((cate){
      if(cate.name == _category){
        typeCategory = cate.type;
      }
    });
    return typeCategory;
  }

  void _showDialog(EditBloc editBloc) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Xóa phiếu"),
          content: new Text("Bạn có chắc muốn xóa phiếu này"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Đồng ý"),
              onPressed: () {
                editBloc.dispatch(
                    Delete(date: transaction.date, id: transaction.id));
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void passEditCategory() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Category()),
    );
    if (result == null) {
      _editBloc.dispatch(LoadCategory());
    }
  }

}
