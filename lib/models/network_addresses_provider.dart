import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/secrets_provider.dart';

import '/util/logger.dart';

part 'network_addresses_provider.g.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

Map<String, String> resolutions = {
  'low': '13',
  'medium': '12',
  'high': '11',
};

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

    final cameraIds = {
      'door': 'Door',
      'garden': 'Garden',
    };

    final cameras = Map.fromEntries(cameraIds.keys.map((id) {
      final camUser = secrets['general']['${id}CamUser'];
      final camPassword = secrets['general']['${id}CamPassword'];
      final camVideoAddress = secrets['network']['${id}CamVideoAddress'];
      final camSnapshotPort = secrets['general']['${id}CamSnapshotPort'];
      final camVideoPort = secrets['network']['${id}CamVideoPort'];

      final map = {
        'snapshotUrl': 'http://$serverAddress:$snapshotPort/cam_image_$id.jpg',
      };

      resolutions.forEach((key, value) {
        final name = key.capitalize();
        map['videoStreamUrl$name'] = 'rtsp://$camUser:$camPassword@$camVideoAddress:$camVideoPort/livestream/$value';

        map['mjpegUrl$name'] =
            'https://$camUser:$camPassword@$camVideoAddress:$camSnapshotPort/livestream/$value?action=play&media=mjpeg&user=$camUser&pwd=$camPassword';
      });

      return MapEntry(id, map);
    }));

    final networkAddresses = {
      'grafana': 'https://$grafanaAddress/d/$grafanaProjectHash/homebase?orgId=1&refresh=10s&from=now-12h&to=now',
      'influxdb': 'https://$influxdbUser:$influxdbPassword@$serverAddress:8085/query?pretty=false',
      'allCameraIds': cameraIds,
      ...cameras,
    };

    logger.i(networkAddresses);
    return networkAddresses;
  }
}
