import 'package:flutter/material.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_state.dart';
import 'package:quanly_thuchi/home_page/tab/bloc/page_event.dart';
import 'package:quanly_thuchi/model/transaction.dart';
import 'package:quanly_thuchi/constant.dart';
import 'package:quanly_thuchi/edit_revenue_expenditure/edit_revenue_expendture.dart';
import 'page_section.dart';
class PageSection2 extends PageSection{
  String dateTime;
  PageSection2({this.dateTime});
}