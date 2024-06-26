import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:home_base_14/models/mqtt_devices.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:home_base_14/pages/home/widgets/prusa_nozzle_widget.dart';

part 'prusa_nozzle_widget_test.g.dart';

@riverpod
class FakePrusa extends _$FakePrusa implements Prusa {
  @override
  IMap<String, dynamic> build() {
    return IMap(const {
      'extruder_actual': 210.0,
      'extruder_target': 200.0,
    });
  }

  @override
  void addAll(data) {
    // TODO: implement addAll
  }
}

void main() {
  group(
    'Widget Tests',
    () {
      testWidgets(
        'Testing PrusaNozzle',
        (tester) async {
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                prusaProvider.overrideWith(() => FakePrusa()),
              ],
              child: MaterialApp(
                home: Scaffold(
                  body: Consumer(
                    builder: (context, ref, _) {
                      return const Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: PrusaNozzle(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(
            (tester.firstWidget(find.byType(SvgPicture)) as SvgPicture).colorFilter,
            ColorFilter.mode(
              nozzleColors[2],
              BlendMode.srcIn,
            ),
          );
          await tester.pumpAndSettle(const Duration(seconds: 3));
        },
      );
    },
  );
}
