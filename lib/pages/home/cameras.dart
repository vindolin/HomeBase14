import 'package:flutter/material.dart';
import '/models/secrets.dart' as secrets;
import '/widgets/refreshable_image_widget.dart';

import '/pages/cams/cam_details_page.dart';
import '/models/mqtt_providers.dart';

Widget cameras() {
  int childCount = 1 * 2;

  return SliverPadding(
    padding: const EdgeInsets.all(8.0),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 110,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 2.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final widgets = [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                // const CamWidget(),  // vlc player widget
              ],
            ),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                // const CamWidget(),
              ],
            ),
            // ...List.generate(
            //   childCount,
            //   (index) => const Icon(
            //     Icons.image_not_supported,
            //     size: 64,
            //   ),
            // ),
          ];

          return index >= widgets.length ? null : widgets[index];
        },
        childCount: childCount,
      ),
    ),
  );
}
