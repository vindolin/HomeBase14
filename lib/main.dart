import 'dart:io' show Platform, SecurityContext;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:home_base_14/utils.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter_portal/flutter_portal.dart';

import '/models/app_settings.dart';
import '/models/mqtt_connection_state_provider.dart';
import 'models/open_connection_data_form_provider.dart';
import '/models/connectivity_provider.dart' as connectivity_rovider; // rename to avoid conflict with Connectivity class
import '/models/mqtt_providers.dart';
// import '/models/generic_providers.dart';
import '/pages/login_page.dart';
import '/pages/home/home_page.dart';
import '/widgets/brightness_button_widget.dart';

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
        // ref.read(appLogProvider.notifier).log('log init');
      },
    );

    // TODOs for later
    // the auto reconnect is not working reliable, so we try to reconnect every second
    // Timer.periodic(const Duration(seconds: 1), (timer) async {
    //   final mqttConnectionState = ref.watch(mqttConnectionStateProvider);
    //   if (![MqttConnectionState.connected, MqttConnectionState.connecting].contains(mqttConnectionState)) {
    //     ref.read(appLogProvider.notifier).log('mqtt reconnect $mqttConnectionState');
    //     ref.watch(mqttProvider.notifier).client.connect();
    //   }
    // });

    // if we don't receive a message for 10 seconds, we try to reconnect
    // this can happen if the app was in the background for a long time
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      // connection data form is open, don't reconnect
      if (ref.watch(openConnectionDataFormProvider)) {
        return;
      }
      final lastMessageTime = ref.watch(lastMessageTimeProvider);
      if (DateTime.now().difference(lastMessageTime).inSeconds > 5) {
        if (ref.watch(mqttConnectionStateProvider) != MqttConnectionState.connecting) {
          ref.read(mqttProvider.notifier).disconnect();
          ref.read(mqttProvider.notifier).connect();
        }
        ref.read(lastMessageTimeProvider.notifier).update();
      }
    });

    Timer(const Duration(seconds: 10), () {
      ref.read(mqttProvider.notifier).disconnect();
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

    return Portal(
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        title: 'HomeBase14',
        debugShowCheckedModeBanner: false,
        home: PortalTarget(
          visible:
              // show only if not connected and when the connection page is not open
              ref.watch(openConnectionDataFormProvider) == false &&
                  ref.watch(mqttConnectionStateProvider) != MqttConnectionState.connected,
          portalFollower: Container(
            color: Colors.black45,
            child: Center(
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: switch (ref.watch(mqttConnectionStateProvider)) {
                    MqttConnectionState.connecting => const CircularProgressIndicator(
                        strokeWidth: 10,
                      ),
                    _ => GestureDetector(
                        onTap: () {
                          ref.watch(openConnectionDataFormProvider.notifier).set(true);
                        },
                        child: const Icon(
                          Icons.wifi_off,
                          size: 120,
                        )),
                  }),
            ),
          ),
          child: ref.watch(openConnectionDataFormProvider) ? LoginFormPage() : const HomePage(),
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
