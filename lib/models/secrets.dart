/// this file only demonstrates how the real file is structured and what variables are set

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
    'videoUrl': 'rtsp://SECRET',
  },
  'garden': {
    'snapshotUrl': 'http://SECRET',
    'videoUrl': 'rtsp://SECRET',
  },
};

const grafanaAdddress = 'https://SECRET/d/000000012/grafana-play-home?orgId=11';
const influxdbUser = 'SECRET';
const influxdbPassword = 'SECRET';
const influxdbAddress = 'http://SECRET/query?pretty=false';
const influxdbDatabase = 'SECRET';
