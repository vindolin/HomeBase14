import 'package:flutter_test/flutter_test.dart';

import 'package:home_base_14/pages/home/widgets/prusa_nozzle_widget.dart';
import 'package:home_base_14/utils.dart';

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
}
