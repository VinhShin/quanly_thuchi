import 'package:quanly_thuchi/model/transaction.dart';
import 'package:quanly_thuchi/model/transaction_header.dart';

class TransactionSection{
  TransactionHeader transactionHeader;
  List<Transaction> transactions;

  TransactionSection({this.transactionHeader, this.transactions});

  factory TransactionSection.init(){
    TransactionHeader transactionHeader = new TransactionHeader(revenue: 0,expendture: 0,total: 0);
    return TransactionSection(transactionHeader: transactionHeader, transactions:  new List());
  }


}