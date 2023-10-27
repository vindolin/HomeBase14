import 'dart:developer' as d;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

// const bool debugTrace = false;
const bool debugTrace = true;

// logs a message with the file and line number
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
      // sort by device name
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
        // sort by device name
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

// compare by multiple compare functions
extension MapMultipleSort<K, V> on Map<K, V> {
  Map<K, V> sortByList(List<CompareFn> compareFns) {
    return Map.fromEntries(entries.toList()..sortByList(compareFns));
  }
}

extension IMapMultipleSort<K, V> on IMap<K, V> {
  IMap<K, V> sortByList(List<CompareFn> compareFns) {
    return IMap.fromEntries(
      entries.toList()..sortByList(compareFns),
    );
  }
}

// var testList = [2, 3, 5, 6];
// var newList = sortByList(testList, [
//   (a, b) => a.compareTo(b),
//   (a, b) => b.compareTo(a),
// ]);

Color lerp3(Color a, Color b, Color c, double t) {
  return t < 0.5 ? Color.lerp(a, b, t / 0.5)! : Color.lerp(b, c, (t - 0.5) / 0.5)!;
}

Color colorClamp3(double actual, double target, colors) {
  Color finalColor = Colors.transparent;

  double position = clampDouble(actual / target, 0.0, 1.0);

  finalColor = lerp3(
    colors[0],
    colors[1],
    colors[2],
    position,
  );
  return finalColor;
}

T valueToItem<T, N extends num>(List<T> items, N value, N max) {
  return items[(value * (items.length - 1) / max).round()];
}
