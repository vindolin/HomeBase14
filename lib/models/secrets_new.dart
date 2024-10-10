// run ..\package_secrets.bat after changing this file!

const networkTypeLocal = 'local';
const networkTypeMobile = 'mobile';

const homebase14Ip = 'domain.de';

const camPassword = r'xxx';

final secretsMap = {
  'general': {
    'snapshotPort': 111,
    'influxdbUser': 'user',
    'influxdbPassword': 'xxx',
    'influxdbDatabase': 'database',
    'doorCamUser': 'user',
    'doorCamPassword': Uri.encodeComponent(camPassword),
    'doorCamSnapshotPort': 1111,
    'gardenCamUser': 'guest',
    'gardenCamPassword': Uri.encodeComponent(camPassword),
    'gardenCamSnapshotPort': 1111,
    'grafanaProjectHash': 'xxx',
  },
  networkTypeLocal: {
    'grafanaAddress': 'domain.de',
    'serverAddress': homebase14Ip,
    'doorCamVideoAddress': 'domain.de',
    'doorCamVideoPort': 111,
    'gardenCamVideoAddress': 'domain.de',
    'gardenCamVideoPort': 111,
    'mqttAddress': homebase14Ip,
    'mqttUsername': 'user',
    'mqttPassword': 'xxx',
    'mqttPort': 1111,
    'mqttEncrypt': true,
  },
  networkTypeMobile: {
    'grafanaAddress': 'domain.de',
    'serverAddress': 'domain.de',
    'doorCamVideoAddress': 'domain.de',
    'doorCamVideoPort': 1111,
    'gardenCamVideoAddress': 'domain.de',
    'gardenCamVideoPort': 1111,
    'mqttAddress': 'domain.de',
    'mqttUsername': 'user',
    'mqttPassword': 'xxx',
    'mqttPort': 1111,
    'mqttEncrypt': true,
  },
  'pooch': 'woof',
};
