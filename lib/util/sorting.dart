import 'package:fast_immutable_collections/fast_immutable_collections.dart';

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
