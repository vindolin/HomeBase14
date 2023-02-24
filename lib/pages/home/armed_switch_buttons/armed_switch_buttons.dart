import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'armed_switch_button_widget.dart';

Widget armedButtons() {
  return SliverPadding(
    padding: const EdgeInsets.all(2.0),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 110,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 2.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final buttons = [
            ArmedSwitchButton(
              id: 'garage',
              label: translate('armed_buttons.garage.label'),
              iconOn: Icons.garage,
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
              iconOff: Icons.local_police_outlined,
              colorOn: Colors.pink,
              colorOff: Colors.orange,
              textOn: translate('armed_buttons.burglar.text_on'),
              textOff: translate('armed_buttons.burglar.text_off'),
              confirm: true,
            ),
            ArmedSwitchButton(
              id: 'camera',
              label: translate('armed_buttons.camera.label'),
              iconOn: Icons.remove_red_eye,
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
              iconOff: Icons.water_drop_outlined,
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
          ];

          return index >= buttons.length ? null : buttons[index];
        },
        childCount: 5,
      ),
    ),
  );
}
