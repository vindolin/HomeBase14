import 'dart:io' show SecurityContext;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter_portal/flutter_portal.dart';

import '/utils.dart';
import '/models/app_settings_provider.dart';
import '/models/mqtt_connection_state_provider.dart';
import '/models/mqtt_providers.dart';
import '/models/connectivity_provider.dart'
    as connectivity_provider; // rename to avoid conflict with Connectivity class
import '/models/secrets_provider.dart';
import 'pages/encryption_key_form_page.dart';
import '/pages/home/home_page.dart';
import '/widgets/brightness_button_widget.dart';
import '/widgets/pulsating_icon_hooks_widget.dart';

const simplePeriodicTask = 'be.tramckrijte.workmanagerExample.simplePeriodicTask';

void main() async {
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'de_DE',
    supportedLocales: ['en_US', 'de_DE'],
  );

  initializeDateFormatting('de_DE', null);

  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  // I had certificate problems with the mjpeg file from my server, this solved it
  // https://stackoverflow.com/questions/54285172/how-to-solve-flutter-certificate-verify-failed-error-while-performing-a-post-req
  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  if (!platformIsDesktop) {
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
  String lastNetworkType = networkTypeLocal;
  @override
  void initState() {
    super.initState();
    loadAppSettings(ref);
  }

  void loadAppSettings(ref) async {
    final connectivityProviderNotifier = connectivity_provider.connectivityProvider.notifier;

    await ref.read(appSettingsProvider.notifier).loadAppSettings();

    // get initial connectivity state
    final result = await Connectivity().checkConnectivity();
    log('connectivityResult: $result');
    ref.read(connectivityProviderNotifier).setResult(result);

    log('init done');

    // listen to changes in connectivity state in the future
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      ref.read(connectivityProviderNotifier).setResult(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(appSettingsProvider);
    final secrets = ref.watch(secretsProvider);
    final networkType = ref.watch(networkTypeProvider);

    if (networkType != lastNetworkType) {
      log('networkType changed: $networkType');
      lastNetworkType = networkType;
      Future(() => ref.read(mqttProvider.notifier).disconnect());
    }

    // connect to mqtt broker if secrets are available and not already connected
    if (secrets.entries.isNotEmpty && ref.read(mqttConnectionStateProvider) != MqttConnectionState.connected) {
      Future(() => ref.read(mqttProvider.notifier).connect(secrets));
    }

    final brightness = ref.watch(brightnessSettingProvider);
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

    final appSettingsValid = ref.watch(appSettingsProvider.select((value) => value.isValid));

    return Portal(
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        title: 'HomeBase14',
        debugShowCheckedModeBanner: false,
        home: PortalTarget(
          visible: ref.watch(mqttConnectionStateProvider.select((value) => value != MqttConnectionState.connected)) &&
              appSettingsValid,
          portalFollower: Container(
            color: Colors.black45,
            child: Center(
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: switch (appSettingsValid) {
                    false => const CircularProgressIndicator(
                        strokeWidth: 10,
                      ),
                    _ => GestureDetector(
                          child: const PulsatingIcon(
                        iconData: Icons.lock,
                        color: Colors.red,
                        size: 100,
                      ))
                  }),
            ),
          ),
          child: !appSettingsValid ? EncryptionKeyFormPage() : const HomePage(),
        ),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: brightness,
          ),
        ),
      ),
    );
  }
}
