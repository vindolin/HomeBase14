import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '/models/connectivity_provider.dart';
import '/models/mqtt_providers.dart';
import '/models/secrets.dart' as secrets;
import '/widgets/refreshable_image_widget.dart';
import '/pages/cams/cam_image_page.dart';
import '/pages/cams/cam_video_page.dart';

const refreshTimeMobile = 120;
const refreshTimeWifi = 5;

Widget camContainer(Widget child) {
  return Container(
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
    child: child,
  );
}

class Cameras extends ConsumerWidget {
  const Cameras({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    bool isMobile = false;

    connectivity.whenData((result) {
      if (result == ConnectivityResult.mobile) {
        isMobile = true;
      } else {
        isMobile = false;
      }
    });

    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: TimerBuilder.periodic(
          Duration(
            seconds: isMobile ? refreshTimeMobile : refreshTimeWifi,
          ), builder: (context) {
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            childAspectRatio: 16 / 9,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final widgets = ['door', 'garden'].map(
                (camId) {
                  return camContainer(
                    RefreshableImage(
                      secrets.camData[camId]!['snapshotUrl']!,
                      streamProvider: doorAlarmProvider,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CamImagePage(camId: camId),
                          ),
                        );
                      },
                      onDoubleTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CamVideoPage(camId: camId),
                          ),
                        );
                      },
                    ),
                  );
                },
              ).toList();
              return index >= widgets.length ? null : widgets[index];
            },
            childCount: 1 * 2,
          ),
        );
      }),
    );
  }
}
