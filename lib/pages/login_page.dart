import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt5_client/mqtt5_client.dart';

import '/utils.dart';
import '/models/app_settings.dart';
import '/models/mqtt_providers.dart';
import '/widgets/password_input_widget.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class LoginFormPage extends ConsumerWidget {
  LoginFormPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppSettingsCls appSettingsCls = ref.watch(appSettingsProvider);
    final Map<String, dynamic> formData = {
      'mqttUsername': appSettingsCls.mqttUsername,
      'mqttPassword': appSettingsCls.mqttPassword,
      'mqttAddress': appSettingsCls.mqttAddress,
      'mqttPort': appSettingsCls.mqttPort,
    };

    log('login form build');

    final Mqtt mqttProviderNotifier = ref.watch(mqttProvider.notifier);
    final AppSettings appSettings = ref.read(appSettingsProvider.notifier);

    void submitForm() async {
      // I'm not sure why, but the snackbar doesn't hide on the first press without this and the hideCurrentSnackBar()'s below
      rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
      if (_formKey.currentState!.validate()) {
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('connecting...'),
            duration: Duration(seconds: 3),
          ),
        );
        _formKey.currentState?.save();
        log('form submit');
        appSettings.saveMqttLoginForm(formData);

        final MqttConnectionState mqttConnectionState = await mqttProviderNotifier.connect();

        // if the connection was successful, persist the connection data
        if (mqttConnectionState == MqttConnectionState.connected) {
          await appSettings.persistAppSettings();
          log('persisted connection data');
          rootScaffoldMessengerKey.currentState
            ?..hideCurrentSnackBar(
                reason: SnackBarClosedReason.dismiss) // TODO_ check why this is needed to really hide the snackbar
            ..showSnackBar(
              const SnackBar(
                content: Text('connected successfully'),
                duration: Duration(seconds: 3),
              ),
            );
        } else {
          rootScaffoldMessengerKey.currentState
            ?..hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss)
            ..showSnackBar(
              const SnackBar(
                content: Text('connection failed'),
                duration: Duration(seconds: 3),
              ),
            );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Login'),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            key: UniqueKey(),
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Username',
              hintText: 'Enter your username',
            ),
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            initialValue: appSettingsCls.mqttUsername,
            onSaved: (String? value) {
              log(value);
              formData['mqttUsername'] = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please enter a username';
              }
              return null;
            },
            onFieldSubmitted: (value) => submitForm(),
          ),
          PasswordField(
            key: UniqueKey(),
            labelText: 'Password',
            maxLength: 20,
            initialValue: appSettingsCls.mqttPassword,
            onSaved: (String? value) {
              formData['mqttPassword'] = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please enter a password';
              }
              return null;
            },
            onFieldSubmitted: (value) => submitForm(),
          ),
          TextFormField(
            key: UniqueKey(),
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Server Address',
              hintText: 'Enter your MQTT server address',
            ),
            initialValue: appSettingsCls.mqttAddress,
            onSaved: (String? value) {
              formData['mqttAddress'] = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please enter a server address';
              }
              return null;
            },
          ),
          TextFormField(
            key: UniqueKey(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Server Port',
              hintText: 'Enter your MQTT server port',
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            initialValue: appSettingsCls.mqttPort.toString(),
            onSaved: (String? value) {
              formData['mqttPort'] = int.parse(value!);
            },
            validator: (value) {
              if (value == null || value.isEmpty || value == '0' || int.parse(value) > 65535) {
                return 'please enter a valid port number (1-65535)';
              }
              return null;
            },
            onFieldSubmitted: (value) => submitForm(),
          ),
          TextButton(
            onPressed: submitForm,
            child: Container(
              color: Colors.green,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: const Center(
                child: Text(
                  'Connect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
