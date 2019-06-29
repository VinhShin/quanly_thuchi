import 'package:meta/meta.dart';
import 'package:quanly_thuchi/model/transaction.dart';

@immutable
class ReportState {
  final bool isSuccess;
  final bool isFailure;

  ReportState({
    @required this.isSuccess,
    @required this.isFailure,
  });

  // ignore: non_constant_identifier_names
  factory ReportState.Init() {
    return ReportState(
      isSuccess: false,
      isFailure: false,
    );
  }
  // ignore: non_constant_identifier_names
  factory ReportState.Success() {
    return ReportState(
      isSuccess: true,
      isFailure: false,
    );
  }
  // ignore: non_constant_identifier_names
  factory ReportState.Failure() {
    return ReportState(
      isSuccess: false,
      isFailure: true,
    );
  }
}
class Reporting extends ReportState{}
class ReportStart extends ReportState{}
class ReportReloaded extends ReportState{}
class ReportAll extends ReportState{
  int  sumRe;
  int  sumEx;
  Map<String,double>  mapCateSumEx;
  Map<String,double>  mapCateSumRe;
  String reportType;
  List<Transaction> listRevenue;
  List<Transaction> listExpendture;
  ReportAll(this.sumRe,this.sumEx,this.mapCateSumEx,this.mapCateSumRe, this.reportType, this.listExpendture, this.listRevenue);
}
