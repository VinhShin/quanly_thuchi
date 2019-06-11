import 'package:quanly_thuchi/model/transaction.dart';
import 'package:quanly_thuchi/model/transaction_header.dart';

class TransactionSection{
  TransactionHeader transactionHeader;
  List<Transaction> transactions;

  TransactionSection({this.transactionHeader, this.transactions});

}