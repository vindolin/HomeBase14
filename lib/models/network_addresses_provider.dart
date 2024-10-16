import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '/utils.dart';
import '/models/secrets_provider.dart';

part 'network_addresses_provider.g.dart';

// const doorVideoWebsocketUrl =
//     'https://$serverAddress:3001/mini.html'; // TODOs add nginx proxy but not used at the moment

@Riverpod(keepAlive: true)
class NetworkAddresses extends _$NetworkAddresses {
  @override
  Map<String, dynamic> build() {
    final secrets = ref.watch(secretsProvider);

    final serverAddress = secrets['network']['serverAddress'];
    final grafanaAddress = secrets['network']['grafanaAddress'];
    final influxdbUser = secrets['general']['influxdbUser'];
    final influxdbPassword = secrets['general']['influxdbPassword'];
    final snapshotPort = secrets['general']['snapshotPort'];
    final grafanaProjectHash = secrets['general']['grafanaProjectHash'];

    final doorCamVideoPort = secrets['network']['doorCamVideoPort'];
    final gardenCamVideoPort = secrets['network']['gardenCamVideoPort'];

    final doorCamUser = secrets['general']['doorCamUser'];
    final doorCamPassword = secrets['general']['doorCamPassword'];
    final doorCamVideoAddress = secrets['network']['doorCamVideoAddress'];
    final doorCamSnapshotPort = secrets['general']['doorCamSnapshotPort'];

    final gardenCamUser = secrets['general']['gardenCamUser'];
    final gardenCamPassword = secrets['general']['gardenCamPassword'];
    final gardenCamVideoAddress = secrets['network']['gardenCamVideoAddress'];
    final gardenCamSnapshotPort = secrets['general']['gardenCamSnapshotPort'];

    final networkAddresses = {
      'grafana': 'https://$grafanaAddress/d/$grafanaProjectHash/homebase?orgId=1&refresh=10s&from=now-12h&to=now',
      'influxdb': 'https://$influxdbUser:$influxdbPassword@$serverAddress:8085/query?pretty=false',
      'allCameraIds': {
        'door': 'Door',
        'garden': 'Garden',
      },
      'door': {
        'snapshotUrl': 'http://$serverAddress:$snapshotPort/cam_image_door.jpg',
        'mjpegUrlLow':
            'https://$doorCamUser:$doorCamPassword@$doorCamVideoAddress:$doorCamSnapshotPort/livestream/13?action=play&media=mjpeg&user=$doorCamUser&pwd=$doorCamPassword',
        'mjpegUrlHigh':
            'https://$doorCamUser:$doorCamPassword@$doorCamVideoAddress:$doorCamSnapshotPort/livestream/11?action=play&media=mjpeg&user=$doorCamUser&pwd=$doorCamPassword',
        'videoStreamUrlLow':
            'rtsp://$doorCamUser:$doorCamPassword@$doorCamVideoAddress:$doorCamVideoPort/livestream/13',
        'videoStreamUrlHigh':
            'rtsp://$doorCamUser:$doorCamPassword@$doorCamVideoAddress:$doorCamVideoPort/livestream/12',
      },
      'garden': {
        'snapshotUrl': 'http://$serverAddress:$snapshotPort/cam_image_garden.jpg',
        'mjpegUrlLow':
            'https://$gardenCamUser:$gardenCamPassword@$gardenCamVideoAddress:$gardenCamSnapshotPort/livestream/13?action=play&media=mjpeg&user=$gardenCamUser&pwd=$gardenCamPassword',
        'mjpegUrlHigh':
            'https://$gardenCamUser:$gardenCamPassword@$gardenCamVideoAddress:$gardenCamSnapshotPort/livestream/11?action=play&media=mjpeg&user=$gardenCamUser&pwd=$gardenCamPassword',
        'videoStreamUrlLow':
            'rtsp://$gardenCamUser:$gardenCamPassword@$gardenCamVideoAddress:$gardenCamVideoPort/livestream/13',
        'videoStreamUrlHigh':
            'rtsp://$gardenCamUser:$gardenCamPassword@$gardenCamVideoAddress:$gardenCamVideoPort/livestream/12',
      },
    };

    // log(networkAddresses);
    return networkAddresses;
  }
}
