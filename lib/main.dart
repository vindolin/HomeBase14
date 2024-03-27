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
import '/models/app_settings.dart';
import '/models/open_login_form_semaphore_provider.dart';
import '/models/connectivity_provider.dart'
    as connectivity_provider; // rename to avoid conflict with Connectivity class
import 'pages/encryption_key_form_page.dart';
import '/pages/home/home_page.dart';
import '/widgets/brightness_button_widget.dart';
import '/widgets/pulsating_icon_hooks_widget.dart';

const simplePeriodicTask = 'be.tramckrijte.workmanagerExample.simplePeriodicTask';

// @pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     switch (task) {
//       case simplePeriodicTask:
//         try {
//           print('$simplePeriodicTask was executed');
//           break;
//         } catch (e) {
//           print('Error in $simplePeriodicTask: $e');
//         }
//     }

//     return Future.value(true);
//   });
// }

void main() async {
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'de_DE',
    supportedLocales: ['en_US', 'de_DE'],
  );

  initializeDateFormatting('de_DE', null);

  // if (Platform.isAndroid) {
  //   Workmanager().registerPeriodicTask(
  //     simplePeriodicTask,
  //     simplePeriodicTask,
  //     frequency: const Duration(minutes: 1),
  //   );
  // }

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

    log('loginOpen: ${ref.watch(openLoginFormSemaphoreProvider)}');
    log('isValid: ${ref.watch(appSettingsProvider).isValid}');
    return Portal(
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        title: 'HomeBase14',
        debugShowCheckedModeBanner: false,
        home: PortalTarget(
          visible: false,
          // visible: ref.watch(openLoginFormSemaphoreProvider) == false &&
          //     ref.watch(mqttConnectionStateProvider) != MqttConnectionState.connected,

          // // show the form only if not connected and when the connection page is not open
          // !ref.watch(openLoginFormSemaphoreProvider) && !ref.watch(appSettingsProvider).isValid,
          portalFollower: Container(
            color: Colors.black45,
            child: Center(
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: switch (ref.watch(appSettingsProvider).isValid) {
                    false => const CircularProgressIndicator(
                        strokeWidth: 10,
                      ),
                    _ => GestureDetector(
                        onTap: () {
                          ref.watch(openLoginFormSemaphoreProvider.notifier).set(true);
                        },
                        child: const PulsatingIcon(
                          iconData: Icons.lock,
                          color: Colors.red,
                          size: 100,
                        ))
                  }),
            ),
          ),
          child: ref.watch(openLoginFormSemaphoreProvider) ? EncryptionKeyFormPage() : const HomePage(),
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
