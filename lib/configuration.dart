import 'package:media_kit/media_kit.dart';

// this seems to have no effect
// https://github.com/media-kit/media-kit/issues/260
const mediakitPlayerLogLevl = MPVLogLevel.error;

const defaultNetworkType = 'mobile'; // I can't use enums here because this is also the key name for the json fields

const testNetworkIntervalSec = 30;
