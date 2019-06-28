import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class ReportEvent extends Equatable{
  ReportEvent([List props = const []]) : super(props);
}
class ReportPressed extends ReportEvent {
  final DateTime datefrom;
  final DateTime dateto;
  final String type;

  ReportPressed({@required this.datefrom, @required this.dateto, @required this.type})
      : super([datefrom, dateto, type]);

  @override
  String toString() {
    return 'ReportPressed { datefrom: $datefrom, dateto: $dateto, type:$type }';
  }
}
class ReportInit extends ReportEvent {
  @override
  String toString() {
    return 'ReportInit';
  }
}
class ReportReload extends ReportEvent {
  @override
  String toString() {
  return 'ReportReload';
  }
}