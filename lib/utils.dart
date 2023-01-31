import 'dart:developer' as d;
import 'package:stack_trace/stack_trace.dart';

// const bool debugTrace = false;
const bool debugTrace = true;

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

Map<K, V> sortByDeviceName<K, V>(Map<K, V> map, Map<String, String> deviceNames) {
  return Map.fromEntries(({...map}).entries.toList()
    ..sort(
      // first sort by device name
      (a, b) => deviceNames[a.key]!.compareTo(
        deviceNames[b.key]!,
      ),
    ));
}

const _sortByDeviceName = sortByDeviceName;

extension NameSorting<K, V> on Map<K, V> {
  Map<K, V> sortByDeviceName(Map<String, String> deviceNames) {
    return _sortByDeviceName(this, deviceNames);
  }
}

List<T> sortByDeviceNameX<T>(List<T> list, Map<String, String> deviceNames) {
  return List.from(
    [...list]..sort(
        // first sort by device name
        (a, b) => deviceNames[a]!.compareTo(
          deviceNames[b]!,
        ),
      ),
  );
}

typedef CompareFn<A, B> = int Function(A a, B b);

List<T> sortByList<T>(List<T> list, List<CompareFn> compareFns) {
  for (final compareFn in compareFns) {
    list.sort(compareFn);
  }
  return list;
}

const _sortByList = sortByList;

extension ListMultipleSort<T> on List<T> {
  List<T> sortByList(List<CompareFn> compareFns) {
    return _sortByList(this, compareFns);
  }
}

extension MapMultipleSort<K, V> on Map<K, V> {
  Map<K, V> sortByList(List<CompareFn> compareFns) {
    return Map.fromEntries((this).entries.toList()..sortByList(compareFns));
  }
}

int compareName(String a, String b) {
  return a.compareTo(b);
}

// var testList = [2, 3, 5, 6];
// var newList = sortByList(testList, [
//   (a, b) => a.compareTo(b),
//   (a, b) => b.compareTo(a),
// ]);
