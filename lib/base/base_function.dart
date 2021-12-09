import 'package:intl/intl.dart';

final hhMmSs = DateFormat("hh:mm:ss");

const oneSecond = Duration(seconds: 1);

String durationToString(int minutes) {
  var d = Duration(minutes: minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
}
