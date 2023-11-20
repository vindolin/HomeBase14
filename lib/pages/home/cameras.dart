import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/secrets.dart' as secrets;
import '/widgets/refreshable_image_widget.dart';
import '/models/mqtt_providers.dart'; //need this for doorAlarmProvider (not needed anymore)
import '/pages/cams/cam_image_page.dart';
import '/pages/cams/cam_video_page.dart';
// import '/pages/cams/media_kit_cam_page.dart';
// import '/pages/cams/mjpeg_cam_image.dart';

Widget _camContainer(Widget child, BuildContext context, String camId) {
  return InkWell(
    child: Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      elevation: 6,
      child: child,
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CamVideoPage(camId: camId),
        ),
      );
    },
    onDoubleTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CamImagePage(camId: camId),
        ),
        // MaterialPageRoute(
        //   builder: (context) => MediaKitCamPage(camId: camId),
        // ),
      );
    },
  );
}

// Shows the cameras side by side
// The cameras are refreshed every n seconds depending on the connection (wifi or mobile)
class Cameras extends ConsumerWidget {
  const Cameras({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          childAspectRatio: 16 / 9,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final widgets = ['door', 'garden'].map(
              (camId) {
                return _camContainer(
                  RefreshableImage(
                    secrets.camData[camId]!['snapshotUrl']!,
                    streamProvider: camId == 'door' ? doorAlarmProvider : null,
                    autoRefresh: true,
                  ),
                  context,
                  camId,
                );
              },
            ).toList();
            return index >= widgets.length ? null : widgets[index];
          },
          childCount: 1 * 2,
        ),
      ),
    );
  }
}
