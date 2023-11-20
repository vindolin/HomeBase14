const encryptionKey = 'SECRET=';

String serverAddress = 'secret.com';

String doorCamUser = 'guest';
String doorCamPassword = Uri.encodeComponent(r'SECRET');
String doorCamSnapshotPort = '0000';
String doorCamVideoPort = '0000';

String gardenCamUser = 'guest';
String gardenCamPassword = r'SECRET';
String gardenCamSnapshotPort = '0000';
String gardenCamVideoPort = '0000';

Map<String, Map<String, String>> camData = {
  'door': {
    'snapshotUrl': 'http://secret.com:0000/cam_image_door.jpg',
    'videoUrl': 'https://$doorCamUser:$doorCamPassword@secret.com:0000/13',
    'rtspUrlLow': 'rtsp://$doorCamUser:$doorCamPassword@secret.com:0000/livestream/13',
    'rtspUrlHigh': 'rtsp://$doorCamUser:$doorCamPassword@secret.com:0000/livestream/11',
    'mjpegUrlLow':
        'https://$doorCamUser:$doorCamPassword@secret.com:0000/livestream/13?action=play&media=mjpeg&user=$doorCamUser&pwd=$doorCamPassword',
    'mjpegUrlHigh':
        'https://$doorCamUser:$doorCamPassword@secret.com:0000/livestream/11?action=play&media=mjpeg&user=$doorCamUser&pwd=$doorCamPassword',
  },
  'garden': {
    'snapshotUrl': 'http://secret.com:0000/cam_image_garden.jpg',
    'rtspUrlLow': 'rtsp://$gardenCamUser:$gardenCamPassword@secret.com:0000/13',
    'rtspUrlHigh': 'rtsp://$gardenCamUser:$gardenCamPassword@secret.com:0000/11',
    'mjpegUrlLow':
        'http://$gardenCamUser:$gardenCamPassword@secret.com:0000/mjpegstream.cgi?-chn=13&-usr=$gardenCamUser&-pwd=$gardenCamPassword',
    'mjpegUrlHigh':
        'http://$gardenCamUser:$gardenCamPassword@secret.com:0000/mjpegstream.cgi?-chn=11&-usr=$gardenCamUser&-pwd=$gardenCamPassword',
  },
};

const doorVideoWebsocketUrl = 'https://secret.com:0000/mini.html'; // TODOs add nginx proxy but not used at the moment
const grafanaAdddress = 'https://secret.com:0000/d/SECRET/homebase?orgId=1&refresh=10s&from=now-12h&to=now';

const influxdbUser = 'app';
const influxdbPassword = 'SECRET';
const influxdbAddress = 'https://$influxdbUser:$influxdbPassword@secret.com:0000/query?pretty=false';
const influxdbDatabase = 'sensors';

const mqttUsername = 'SECRET';
const mqttPassword = 'SECRET';
const mqttAddress = 'secret.com';
const mqttPort = 0000;
