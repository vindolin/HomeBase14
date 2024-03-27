import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/utils.dart';
import '/models/encryption.dart' as encryption;

part 'app_settings.g.dart';
part 'app_settings.freezed.dart';

const settingsEncryptionKey = 'LwZoBvGNmA46wQ0M5ExyFF7pzoHyaCs6//Sptpa6hMk=';
const secretEncrypted = 'E6uORLgS';
const secretDecrypted = 'secret';

enum User {
  thomas,
  mona,
}

@freezed
class AppSettingsCls with _$AppSettingsCls {
  const factory AppSettingsCls({
    required bool isValid,
    required String encryptionKey,
    required User user,
    required bool onlyPortrait,
    required bool showBrightness,
    required int camRefreshRateWifi,
    required int camRefreshRateMobile,
    required bool showVideo,
    // required int showVideo,
  }) = _AppSettingsCls;
  factory AppSettingsCls.fromJson(Map<String, dynamic> json) => _$AppSettingsClsFromJson(json);
}

@Riverpod(keepAlive: true)
class AppSettings extends _$AppSettings {
  @override
  AppSettingsCls build() {
    return const AppSettingsCls(
      isValid: false,
      encryptionKey: '',
      user: User.thomas,
      onlyPortrait: true,
      showBrightness: false,
      camRefreshRateWifi: 5,
      camRefreshRateMobile: 20,
      showVideo: true,
    );
  }

  void setIsValid(bool isValid) {
    state = state.copyWith(isValid: isValid);
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

  bool saveEncryptionKey(String encryptionKey) {
    // log(encryptionKey);
    state = state.copyWith(
      encryptionKey: encryptionKey,
    );

    log('----');
    final encryptionTest = encryption.testEncryption(
      encryptionKey,
      secretEncrypted,
      secretDecrypted,
    );

    if (encryptionTest) {
      setIsValid(true);
    }

    return encryptionTest;
  }

  Future<void> persistAppSettings() async {
    log('persistSettings...');
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    String plainText = jsonEncode(state);

    // encrypt the connection data
    final encrypted = encryption.encrypt(settingsEncryptionKey, plainText);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('settings', encrypted);
  }

  Future<void> loadAppSettings() async {
    log('loadSettings...');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userPref = prefs.getString('settings');
    String appSettings;
    if (userPref != null) {
      // log('userprefs: $userPref');

      // decrypt the connection data
      appSettings = encryption.decrypt(
        settingsEncryptionKey,
        userPref,
      );

      // log('appsettings: $appSettings');

      try {
        final json = jsonDecode(appSettings);
        state = AppSettingsCls.fromJson(json);
      } catch (e) {
        log('error loading settings: $e');
      }
    } else {
      // ref.watch(openLoginFormSemaphoreProvider.notifier).set(false);s
      log('no settings found');
    }
  }
}
