import 'package:thuchi/model/transaction.dart';
import 'package:thuchi/model/transaction_header.dart';

class TransactionSection{
  String time;
  TransactionHeader transactionHeader;
  List<Transaction> transactions;

  TransactionSection({this.time, this.transactionHeader, this.transactions});

  factory TransactionSection.init(){
    TransactionHeader transactionHeader = new TransactionHeader(revenue: 0,expendture: 0,total: 0);
    return TransactionSection(transactionHeader: transactionHeader, transactions:  new List());
  }


}