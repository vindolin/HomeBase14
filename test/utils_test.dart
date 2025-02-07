import 'package:flutter_test/flutter_test.dart';

import 'package:home_base_14/pages/home/widgets/prusa_nozzle_widget.dart';
import 'package:home_base_14/utils.dart';
import 'package:home_base_14/util/color.dart';
import 'package:home_base_14/util/sorting.dart';

void main() {
  group(
    'Function Tests',
    () {
      testWidgets(
        'Testing colorFromTemps',
        (tester) async {
          expect(colorClamp3(-10.0, 200.0, nozzleColors), nozzleColors[0]);
          expect(colorClamp3(0.0, 200.0, nozzleColors), nozzleColors[0]);
          expect(colorClamp3(210.0, 200.0, nozzleColors), nozzleColors[2]);
        },
      );
    },
  );

  group(
    'Sort Test',
    () {
      test('sortByDeviceName sorts map by device name', () {
        final map = {
          'deviceA': 'valA',
          'deviceC': 'valC',
          'deviceB': 'valB',
        };
        final deviceNames = {
          'deviceA': 'Zed Device',
          'deviceC': 'Mid Device',
          'deviceB': 'Alpha Device',
        };

        final sorted = sortByDeviceName(map, deviceNames);
        expect(sorted.keys.toList(), equals(['deviceB', 'deviceC', 'deviceA']));
      });

      test('sortByList sorts a list with multiple compare functions', () {
        final data = [3, 1, 2, 5, 4];
        final sorted = sortByList<int>(
          data,
          [
            (a, b) => a.compareTo(b), // ascending
            (a, b) => b.compareTo(a), // then descending
          ],
        );
        expect(sorted, equals([5, 4, 3, 2, 1]));
      });
    },
  );

  group('valueToItem Tests', () {
    test('returns first item when value is 0', () {
      final items = ['a', 'b', 'c', 'd'];
      // value=0 should select the first item.
      expect(valueToItem(items, 0, 100), equals('a'));
    });

    test('returns last item when value equals max', () {
      final items = [10, 20, 30, 40];
      // value equals max should select the last item.
      expect(valueToItem(items, 100, 100), equals(40));
    });

    test('returns correct item for a mid value', () {
      final items = [10, 20, 30, 40];
      // For value=50, index = (50*(4-1)/100) = (150/100)=1.5 rounds to 2.
      expect(valueToItem(items, 50, 100), equals(30));
    });
  });

  group('mapValue Tests', () {
    test('maps mid value correctly', () {
      // mapping 5 from range 0-10 to 0-100 should be 50.
      expect(mapValue(5.0, 0.0, 10.0, 0.0, 100.0), equals(50.0));
    });

    test('maps lower bound correctly', () {
      // mapping 0 from range 0-10 to 20-80 should be 20.
      expect(mapValue(0.0, 0.0, 10.0, 20.0, 80.0), equals(20.0));
    });

    test('maps upper bound correctly', () {
      // mapping 10 from range 0-10 to 20-80 should be 80.
      expect(mapValue(10.0, 0.0, 10.0, 20.0, 80.0), equals(80.0));
    });

    test('maps arbitrary value correctly', () {
      // mapping 15 from range 10-20 to 0-200 should be 100.
      expect(mapValue(15.0, 10.0, 20.0, 0.0, 200.0), equals(100.0));
    });
  });
}
