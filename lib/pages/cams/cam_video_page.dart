import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:media_kit/media_kit.dart';
import '/widgets/media_kit_video_widget.dart';
import '/models/network_addresses_provider.dart';

class CamVideoPage extends ConsumerWidget {
  final String camId;

  const CamVideoPage({super.key, required this.camId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkAddresses = ref.watch(networkAddressesProvider);

    final thisCam = Media(networkAddresses[camId]!['videoStreamUrlHigh']!);

    // onTap cycles through all cameras
    final otherCams = networkAddresses['allCameraIds'].keys.where((id) {
      return id != camId;
    }).map(
      (id) {
        return Media(networkAddresses[id]!['videoStreamUrlHigh']!);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('cams.$camId')),
      ),
      body: RotatedBox(
        quarterTurns: MediaQuery.of(context).orientation == Orientation.portrait && !Platform.isWindows ? 1 : 0,
        child: MediaKitVideoWidget(
          videoUrls: Playlist(
            [
              thisCam,
              ...otherCams,
            ],
          ),
        ),
      ),
    );
  }
}
