import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '/widgets/media_kit_video_widget.dart';
import '/models/network_addresses_provider.dart';

class CamVideoPage extends ConsumerWidget {
  final String camId;

  const CamVideoPage({super.key, required this.camId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkAddresses = ref.watch(networkAddressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('cams.$camId')),
      ),
      body: RotatedBox(
        quarterTurns: MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 0,
        child: MediaKitVideoWidget(
          videoUrl: networkAddresses[camId]!['videoStreamUrlHigh']!,
        ),
      ),
    );
  }
}
