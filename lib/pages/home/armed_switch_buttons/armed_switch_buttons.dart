import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/widgets/shader_widget.dart';
import 'armed_switch_button_widget.dart';
import '../widgets/prusa_progress_widget.dart';

class ArmedButtons extends StatelessWidget {
  const ArmedButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(2.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 110,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 2.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final buttons = [
              ArmedSwitchButton(
                id: 'garage',
                label: translate('armed_buttons.garage.label'),
                iconOn: Icons.garage_outlined,
                iconOff: Icons.garage,
                colorOn: Colors.pink,
                colorOff: Colors.green,
                textOn: translate('armed_buttons.garage.text_on'),
                textOff: translate('armed_buttons.garage.text_off'),
                confirm: true,
              ),
              ArmedSwitchButton(
                id: 'burglar',
                label: translate('armed_buttons.burglar.label'),
                iconOn: Icons.local_police_outlined,
                iconOff: Icons.local_police,
                colorOn: Colors.pink,
                colorOff: Colors.orange,
                textOn: translate('armed_buttons.burglar.text_on'),
                textOff: translate('armed_buttons.burglar.text_off'),
                confirm: true,
              ),
              ArmedSwitchButton(
                id: 'camera',
                label: translate('armed_buttons.camera.label'),
                iconOn: Icons.remove_red_eye_outlined,
                iconOff: Icons.remove_red_eye,
                colorOn: Colors.pink,
                colorOff: Colors.purple,
                textOn: translate('armed_buttons.camera.text_on'),
                textOff: translate('armed_buttons.camera.text_off'),
                confirm: true,
              ),
              ArmedSwitchButton(
                id: 'pump',
                label: translate('armed_buttons.pump.label'),
                iconOn: Icons.water_drop_outlined,
                iconOff: Icons.water_drop,
                colorOn: Colors.pink,
                colorOff: Colors.blue,
                textOn: translate('armed_buttons.pump.text_on'),
                textOff: translate('armed_buttons.pump.text_off'),
                confirm: true,
              ),
              ArmedSwitchButton(
                id: 'tv',
                label: translate('armed_buttons.tv.label'),
                iconOn: Icons.tv,
                iconOff: Icons.tv_off,
                colorOn: Colors.pink,
                colorOff: Colors.lime,
                textOn: translate('armed_buttons.tv.text_on'),
                textOff: translate('armed_buttons.tv.text_off'),
                confirm: false,
              ),
              ArmedSwitchButton(
                id: 'silence',
                label: translate('armed_buttons.silence.label'),
                iconOn: Icons.volume_off,
                iconOff: Icons.volume_up,
                colorOn: Colors.pink,
                colorOff: Colors.cyan,
                textOn: translate('armed_buttons.silence.text_on'),
                textOff: translate('armed_buttons.silence.text_off'),
                confirm: false,
              ),
              Random().nextDouble() > 0.5
                  ? const ShaderBox(
                      // 'raymarching_basic.frag',
                      'plasma_cube.frag',
                    )
                  : const ShaderBox(
                      'flubber.frag',
                      parameters: [
                        ...[0.16, 0.49, .24] /* light1 */,
                        ...[.19, .9, .03] /* light2 */,
                      ],
                      slowDown: 6.0,
                      // 'pulsing_guts.frag',
                      // parameters: [
                      //   ...[4.0, 2.0, 1.0] /* color */,
                      // ],
                      // slowDown: 3,
                    ),
              const PrusaProgress(),
              // const Card(child: Text('BUMP')),
            ];

            return index >= buttons.length ? null : buttons[index];
          },
          childCount: 8,
        ),
      ),
    );
  }
}
