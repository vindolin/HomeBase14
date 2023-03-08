import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

import '/models/mqtt_providers.dart';
import '/models/secrets.dart' as secrets;
import '/widgets/refreshable_image_widget.dart';
import '/pages/cams/cam_details_page.dart';

Widget cameras() {
  int childCount = 1 * 2;

  return SliverPadding(
    padding: const EdgeInsets.all(8.0),
    sliver: TimerBuilder.periodic(const Duration(seconds: 30), builder: (context) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          childAspectRatio: 16 / 9,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final widgets = [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: RefreshableImage(
                  secrets.camData['door']!['snapshotUrl']!,
                  streamProvider: doorAlarmProvider,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CamDetailPage(camId: 'door'),
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: RefreshableImage(
                  secrets.camData['garden']!['snapshotUrl']!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CamDetailPage(camId: 'garden'),
                      ),
                    );
                  },
                ),
              ),
            ];

            return index >= widgets.length ? null : widgets[index];
          },
          childCount: childCount,
        ),
      );
    }),
  );
}
