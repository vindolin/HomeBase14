import 'dart:io';
import 'dart:developer' as d;
import 'package:stack_trace/stack_trace.dart';

// todo split into own libraries

const bool debug = true;
// const bool debug = false;
const bool debugTrace = true;
// const bool debugTrace = false;

// logs a message with the file and line number
void log(dynamic message) {
  if (!debug) return;
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

/// Returns the value of a list at a certain percentage
T valueToItem<T, N extends num>(List<T> items, N value, N max) {
  return items[(value * (items.length - 1) / max).round()];
}

/// map value from one range to another
double mapValue(double value, double inMin, double inMax, double outMin, double outMax) {
  return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}

bool platformIsDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
