const encryptionKey = 'SECRET_USED_FOR_SETTINGS_ENCRYPTION';

String serverAddress = 'flutter.dev';

String doorCamUser = 'SECRET';
String doorCamPassword = Uri.encodeComponent(r'SECRET');
String doorCamSnapshotPort = '0815';
String doorCamVideoPort = '0815';

String gardenCamUser = 'guest';
String gardenCamPassword = r'SECRET';
String gardenCamSnapshotPort = '0815';
String gardenCamVideoPort = '0815';

Map<String, Map<String, String>> camData = {
  'door': {
    'snapshotUrl': 'http://SECRET',
    'videoUrl': 'rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4',
  },
  'garden': {
    'snapshotUrl': 'http://SECRET',
    'videoUrl': 'rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4',
  },
};

const grafanaAdddress = 'https://play.grafana.org/d/000000012/grafana-play-home?orgId=1';
const influxdbUser = 'SECRET';
const influxdbPassword = 'SECRET';
const influxdbAddress = 'http://SECRET/query?pretty=false';
const influxdbDatabase = 'SECRET';
