import 'secrets.dart';

Map<String, Map<String, String>> camSettings = {
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

const doorVideoWebsocketUrl =
    'https://$serverAddress:3001/mini.html'; // TODOs add nginx proxy but not used at the moment

const grafanaAdddress =
    'https://$serverAddress:3000/d/$grafanaProjectHash/homebase?orgId=1&refresh=10s&from=now-12h&to=now';
const influxdbAddress = 'https://$influxdbUser:$influxdbPassword@$serverAddress:8085/query?pretty=false';
