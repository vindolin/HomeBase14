// import 'package:wakelock/wakelock.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '/utils.dart';

import '/models/app_settings.dart';
import '/models/mqtt_connection_state_provider.dart';
import '/models/mqtt_providers.dart';
import '/pages/login_page.dart';
import '/pages/home/home_page.dart';

void main() async {
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'de_DE',
    supportedLocales: ['en_US', 'de_DE'],
  );

  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    KeepScreenOn.turnOn();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then(
      (value) => runApp(
        ProviderScope(
          child: LocalizedApp(delegate, const HomerApp()),
        ),
      ),
    );
  } else {
    runApp(
      ProviderScope(
        child: LocalizedApp(delegate, const HomerApp()),
      ),
    );
  }
}

class HomerApp extends ConsumerStatefulWidget {
  const HomerApp({super.key});
  @override
  ConsumerState<HomerApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<HomerApp> {
  @override
  void initState() {
    super.initState();
    ref.read(appSettingsProvider.notifier).loadConnectionData().then(
          (_) => ref.watch(mqttProvider.notifier).connect(),
        );
  }

  @override
  Widget build(BuildContext context) {
    log('HomerApp.build()');

    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'Homer',
      debugShowCheckedModeBanner: false,
      home: [
        // show login form only when disconnected/not connecting
        MqttConnectionState.connected,
        MqttConnectionState.connecting,
      ].contains(ref.watch(mqttConnectionStateXProvider))
          ? const HomePage()
          // ? const HomePage()
          : LoginFormPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness,
          surface: const Color.fromARGB(255, 153, 4, 145),
        ),
        // textTheme: TextTheme(),
      ),
    );
  }
}
