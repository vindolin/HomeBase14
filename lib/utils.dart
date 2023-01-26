import 'dart:developer' as d;
import 'package:stack_trace/stack_trace.dart';

const bool debugTrace = false;

void log(dynamic message) {
  if (debugTrace) {
    final trace = Frame.caller(1).location;
    d.log('$message $trace');
  } else {
    d.log(message);
  }
  // final re = RegExp(r'(?<file>\w+\.dart) (?<line>\d+\:\d+)');
  // final match = re.firstMatch(trace);
  // if (match != null) {
  //   final file = match.namedGroup('file');
  //   final line = match.namedGroup('line');
  //   d.log('$message $trace');
  // }
}
