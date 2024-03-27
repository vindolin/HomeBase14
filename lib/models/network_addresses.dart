import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'secrets.dart';

part 'network_addresses.g.dart';

// const doorVideoWebsocketUrl =
//     'https://$serverAddress:3001/mini.html'; // TODOs add nginx proxy but not used at the moment

@riverpod
class NetworkAddresses extends _$NetworkAddresses {
  @override
  Map<String, dynamic> build() {
    final secrets = ref.watch(secretsProvider);

    final serverAddress = secrets['network']['serverAddress'];
    final doorCamVideoPort = secrets['network']['doorCamVideoPort'];
    final gardenCamVideoPort = secrets['network']['gardenCamVideoPort'];

    final doorCamUser = secrets['general']['doorCamUser'];
    final doorCamPassword = secrets['general']['doorCamPassword'];
    final doorCamSnapshotPort = secrets['general']['doorCamSnapshotPort'];

    final gardenCamUser = secrets['general']['gardenCamUser'];
    final gardenCamPassword = secrets['general']['gardenCamPassword'];
    final gardenCamSnapshotPort = secrets['general']['gardenCamSnapshotPort'];

    return {
      'grafana': 'https://$grafanaAddress/d/$grafanaProjectHash/homebase?orgId=1&refresh=10s&from=now-12h&to=now',
      'influxdb': 'https://$influxdbUser:$influxdbPassword@$serverAddress:8085/query?pretty=false',
      'door': {
        'snapshotUrl': 'http://$serverAddress:$snapshotPort/cam_image_door.jpg',
        'mjpegUrlLow':
            'https://$doorCamUser:$doorCamPassword@$serverAddress:$doorCamSnapshotPort/livestream/13?action=play&media=mjpeg&user=$doorCamUser&pwd=$doorCamPassword',
        'mjpegUrlHigh':
            'https://$doorCamUser:$doorCamPassword@$serverAddress:$doorCamSnapshotPort/livestream/11?action=play&media=mjpeg&user=$doorCamUser&pwd=$doorCamPassword',
        'videoStreamUrl': 'rtsp://$doorCamUser:$doorCamPassword@$serverAddress:$doorCamVideoPort/livestream/12',
      },
      'garden': {
        'snapshotUrl': 'http://$serverAddress:$snapshotPort/cam_image_garden.jpg',
        'mjpegUrlLow':
            'http://$gardenCamUser:$gardenCamPassword@$serverAddress:$gardenCamSnapshotPort/mjpegstream.cgi?-chn=13&-usr=$gardenCamUser&-pwd=$gardenCamPassword',
        'mjpegUrlHigh':
            'http://$gardenCamUser:$gardenCamPassword@$serverAddress:$gardenCamSnapshotPort/mjpegstream.cgi?-chn=11&-usr=$gardenCamUser&-pwd=$gardenCamPassword',
        'videoStreamUrl': 'rtsp://$gardenCamUser:$gardenCamPassword@$serverAddress:$gardenCamVideoPort/11',
      },
    };
  }
}
