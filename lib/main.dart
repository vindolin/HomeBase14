import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../config.dart' as config;
import 'package:mqtt_client/mqtt_client.dart';
import 'utils.dart';
import 'models/mqtt_connection_data.dart';
import 'models/mqtt_providers.dart';
import 'scaffold_messenger.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
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
      title: 'Counter App',
      debugShowCheckedModeBanner: false,
      home: [
        // show login form only when disconnected/not connecting
        MqttConnectionState.connected,
        MqttConnectionState.connecting,
      ].contains(ref.watch(mqttConnectionStateXProvider))
          ? const HomePage()
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
