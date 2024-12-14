import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

import '/utils.dart';
import '/models/app_settings_provider.dart';
import '/models/mqtt_providers.dart'; //need this for doorAlarmProvider (not needed anymore)
import '/models/network_addresses_provider.dart';
import '/widgets/media_kit_video_widget.dart';
import '/widgets/refreshable_image_widget.dart';
import '/pages/cams/cam_image_page.dart';
import '/pages/cams/fullscreen_cam_video_page.dart';

import '/util/logger.dart';

Widget _camContainer(Widget child, BuildContext context, String camId, Map<String, dynamic> camSettings) {
  final currentCam = Media(camSettings[camId]!['videoStreamUrlHigh']!);

  final otherCams = camSettings['allCameraIds'].keys.where((id) {
    return id != camId;
  }).map(
    (id) {
      return Media(camSettings[id]!['videoStreamUrlHigh']!);
    },
  );
  final playlist = Playlist([currentCam, ...otherCams]);

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
          // builder: (context) => CamVideoPage(camId: camId),
          builder: (context) => FullscreenCamVideo(videoUrls: playlist),
        ),
      );
    },
    onDoubleTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CamImagePage(camId: camId),
        ),
      );
    },
    // onSecondaryTap: () {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => SideBySideCamsPage(camId: camId),
    //     ),
    //   );
    // },
  );
}

// Shows the cameras side by side
class Cameras extends ConsumerWidget {
  const Cameras({super.key});

  Playlist buildPlaylistForAllCams(resolution, camId, camSettings) {
    final currentCam = Media(camSettings[camId]![resolution]!);
    final otherCams = camSettings['allCameraIds'].keys.where((id) {
      return id != camId;
    }).map((id) {
      return Media(camSettings[id]![resolution]!);
    });
    return Playlist([currentCam, ...otherCams]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camSettings = ref.watch(networkAddressesProvider);
    // showVideo is a boolean that determines whether to show the video stream or the snapshot
    // configurable in the settings page
    final showVideo = ref.watch(
      appSettingsProvider.select((appSettings) => appSettings.showVideo),
    );
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
                if (showVideo) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(5), // adjust the value as needed
                    child: GestureDetector(
                      onTap: () {
                        logger.d('Cameras onTap');
                      },
                      child: MediaKitVideoWidget(
                        videoUrls: Playlist([Media(camSettings[camId]!['videoStreamUrlLow']!)]),
                        muted: true,
                        onTap: () {
                          logger.d('Cameras onTap');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullscreenCamVideo(
                                videoUrls: buildPlaylistForAllCams(
                                  platformIsDesktop ? 'videoStreamUrlHigh' : 'videoStreamUrlMedium',
                                  camId,
                                  camSettings,
                                ),
                              ),
                            ),
                          );
                        },
                        // controls: (state) {
                        //   return Icon(
                        //     Icons.pause,
                        //     size: 128,
                        //     color: Colors.white,
                        //   );
                        // },
                      ),
                    ),
                  );
                } else {
                  return _camContainer(
                    RefreshableImage(
                      camSettings[camId]!['snapshotUrl']!,
                      streamProvider: camId == 'door' ? doorAlarmProvider : null,
                      autoRefresh: true,
                    ),
                    context,
                    camId,
                    camSettings,
                  );
                }
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
