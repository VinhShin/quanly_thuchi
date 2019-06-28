import 'package:meta/meta.dart';
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
  int  tongThu;
  int  tongChi;
  Map<String,int>  mapCateSum;
  ReportAll(this.tongThu,this.tongChi,this.mapCateSum);
}
