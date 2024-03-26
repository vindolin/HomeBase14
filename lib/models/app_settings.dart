import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '/utils.dart';
import 'secrets.dart' as secrets;

part 'app_settings.g.dart';
part 'app_settings.freezed.dart';

enum User {
  thomas,
  mona,
}

final encrypter = encrypt.Encrypter(
  encrypt.Salsa20(
    encrypt.Key.fromUtf8(secrets.certEncryptionKey),
  ),
);

// final iv = encrypt.IV.fromLength(8);
final iv = encrypt.IV.fromBase64('4ygMAg7aRyw=');

@freezed
class AppSettingsCls with _$AppSettingsCls {
  const factory AppSettingsCls({
    required String encryptionKey,
    required User user,
    required bool valid,
    required bool onlyPortrait,
    required bool showBrightness,
    required int camRefreshRateWifi,
    required int camRefreshRateMobile,
    required bool showVideo,
    // required int showVideo,
  }) = _AppSettingsCls;
  factory AppSettingsCls.fromJson(Map<String, dynamic> json) => _$AppSettingsClsFromJson(json);
}

@riverpod
class AppSettings extends _$AppSettings {
  @override
  AppSettingsCls build() {
    return const AppSettingsCls(
      encryptionKey: secrets.certEncryptionKey,
      user: User.thomas,
      valid: false,
      onlyPortrait: true,
      showBrightness: false,
      camRefreshRateWifi: 5,
      camRefreshRateMobile: 20,
      showVideo: true,
      // showVideo: true,
    );
  }

  // TODOs add certificate upload (currently hardcoded in mqtt_providers.dart)

  void setValid(bool valid) {
    state = state.copyWith(valid: valid);
  }

  void saveUser(User user) async {
    state = state.copyWith(
      user: user,
    );
    await persistAppSettings();
  }

  void saveOnlyPortrait(bool onlyPortrait) async {
    state = state.copyWith(
      onlyPortrait: onlyPortrait,
    );
    await persistAppSettings();
  }

  void saveShowBrightness(bool showBrightness) async {
    state = state.copyWith(
      showBrightness: showBrightness,
    );
    await persistAppSettings();
  }

  void saveCamRefreshRateWifi(int duration) async {
    state = state.copyWith(
      camRefreshRateWifi: duration,
    );
    await persistAppSettings();
  }

  void saveCamRefreshRateMobile(int duration) async {
    state = state.copyWith(
      camRefreshRateMobile: duration,
    );
    await persistAppSettings();
  }

  void saveShowVideo(bool value) async {
    state = state.copyWith(
      showVideo: value,
    );
    await persistAppSettings();
  }

  void saveEncryptionKey(String encryptionKey) {
    state = state.copyWith(
      encryptionKey: encryptionKey,
    );
  }

  Future<void> persistAppSettings() async {
    log('persistSettings...');
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    String plainText = jsonEncode(state);

    // encrypt the connection data
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('settings', encrypted.base64);
  }

  Future<void> loadAppSettings() async {
    log('loadSettings...');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userPref = prefs.getString('settings');
    String appSettings;
    if (userPref != null) {
      // decrypt the connection data
      appSettings = encrypter.decrypt(
        encrypt.Encrypted.fromBase64(userPref),
        iv: iv,
      );

      try {
        state = AppSettingsCls.fromJson(jsonDecode(appSettings));
      } catch (e) {
        log('Error: $e');
      }
    } else {}
  }
}
