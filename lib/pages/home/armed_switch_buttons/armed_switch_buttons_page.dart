import 'package:flutter/material.dart';
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
            const ArmedSwitchButton(
              'garage',
              Icons.garage,
              Icons.garage,
              Colors.pink,
              Colors.green,
            ),
            const ArmedSwitchButton(
              'burglar',
              Icons.local_police_outlined,
              Icons.local_police_outlined,
              Colors.pink,
              Colors.orange,
            ),
            const ArmedSwitchButton(
              'camera',
              Icons.remove_red_eye,
              Icons.remove_red_eye,
              Colors.pink,
              Colors.lime,
            ),
            const ArmedSwitchButton(
              'pump',
              Icons.water_drop_outlined,
              Icons.water_drop_outlined,
              Colors.pink,
              Colors.blue,
            ),
          ];

          return index >= buttons.length ? null : buttons[index];
        },
        childCount: 4,
      ),
    ),
  );
}
