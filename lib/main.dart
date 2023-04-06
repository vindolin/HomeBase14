import 'dart:io' show Platform, SecurityContext;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/date_symbol_data_local.dart';

import '/models/app_settings.dart';
import '/models/mqtt_connection_state_provider.dart';
import '/models/connectivity_provider.dart' as connectivity_rovider; // rename to avoid conflict with Connectivity class
import '/models/mqtt_providers.dart';
import '/pages/login_page.dart';
import '/pages/home/home_page.dart';
// import '/pages/home/connecting_page.dart';
import '/widgets/brightness_button_widget.dart';

void main() async {
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'de_DE',
    supportedLocales: ['en_US', 'de_DE'],
  );

  initializeDateFormatting('de_DE', null);

  WidgetsFlutterBinding.ensureInitialized();

  // I had certificate problems with the mjpeg file from my server, this solved it
  // https://stackoverflow.com/questions/54285172/how-to-solve-flutter-certificate-verify-failed-error-while-performing-a-post-req
  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  if (Platform.isAndroid) {
    KeepScreenOn.turnOn();
  }

  runApp(
    ProviderScope(
      child: LocalizedApp(delegate, const HomeBase14App()),
    ),
  );
}

class HomeBase14App extends ConsumerStatefulWidget {
  const HomeBase14App({super.key});
  @override
  ConsumerState<HomeBase14App> createState() => _HomeBase14AppState();
}

class _HomeBase14AppState extends ConsumerState<HomeBase14App> {
  @override
  void initState() {
    super.initState();

    // listen to changes in connectivity state
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      ref.read(connectivity_rovider.connectivityProvider.notifier).setResult(result);
    });

    // load connection data from shared preferences
    ref.read(appSettingsProvider.notifier).loadAppSettings().then(
      (_) async {
        ref.watch(mqttProvider.notifier).connect();
      },
    );

    Future(
      () async {
        // get initial connectivity state
        ref
            .read(connectivity_rovider.connectivityProvider.notifier)
            .setResult(await Connectivity().checkConnectivity());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = ref.watch(brightnessSettingProvider);
    final appSettings = ref.watch(appSettingsProvider);

    // set orientation according to app settings
    if (appSettings.onlyPortrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'HomeBase14',
      debugShowCheckedModeBanner: false,
      home: [
        // show login form only when disconnected/not connecting
        MqttConnectionState.connected,
        MqttConnectionState.connecting,
      ].contains(
        ref.watch(mqttConnectionStateProvider),
      )
          ? const HomePage()
          // : const ConnectingPage(),
          : LoginFormPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 153, 4, 145),
          brightness: brightness,
          surface: const Color.fromARGB(255, 153, 4, 145),
        ),
        // textTheme: TextTheme(),
      ),
    );
  }
}
