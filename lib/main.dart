import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import '../config.dart' as config;
import 'package:mqtt_client/mqtt_client.dart';
import 'utils.dart';
import '/models/mqtt_connection_data.dart';
import '/models/mqtt_providers.dart';
import '/pages/login_page.dart';
// import 'pages/home_page.dart';
import 'pages/home_page/home_page.dart';

void main() async {
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'de_DE',
    supportedLocales: ['en_US', 'de_DE'],
  );
  runApp(
    ProviderScope(
      child: LocalizedApp(delegate, const HomerApp()),
    ),
  );
}

class HomerApp extends ConsumerStatefulWidget {
  const HomerApp({super.key});
  @override
  ConsumerState<HomerApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<HomerApp> {
  // const MyApp({super.key});
  @override
  void initState() {
    super.initState();
    ref.read(mqttConnectionDataXProvider.notifier).loadConnectionData().then(
          (_) => ref.watch(mqttProvider.notifier).connect(),
        );
  }

  @override
  Widget build(BuildContext context) {
    log('MyApp.build()');

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
      ),
    );
  }
}
