import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '/utils.dart';
import '/models/mqtt_connection_data.dart';
import '/models/mqtt_providers.dart';
import '/widgets/password_input_widget.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class LoginFormPage extends ConsumerWidget {
  late final Map<String, dynamic> formData;
  LoginFormPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MqttConnectionDataClass mqttConnectionData = ref.watch(mqttConnectionDataXProvider);
    Map<String, dynamic> formData = {
      'mqttUsername': mqttConnectionData.mqttUsername,
      'mqttPassword': mqttConnectionData.mqttPassword,
      'mqttAddress': mqttConnectionData.mqttAddress,
      'mqttPort': mqttConnectionData.mqttPort,
    };

    log('login form build');

    final Mqtt mqttProviderX = ref.watch(mqttProvider.notifier);
    final MqttConnectionDataX mqttConnectionDataX = ref.read(mqttConnectionDataXProvider.notifier);

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
        mqttConnectionDataX.save(formData);

        final MqttConnectionState mqttConnectionState = await mqttProviderX.connect();

        // if the connection was successful, persist the connection data
        if (mqttConnectionState == MqttConnectionState.connected) {
          await mqttConnectionDataX.persistConnectionData();
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
            initialValue: mqttConnectionData.mqttUsername,
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
            initialValue: mqttConnectionData.mqttPassword,
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
            initialValue: mqttConnectionData.mqttAddress,
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
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
            initialValue: mqttConnectionData.mqttPort.toString(),
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
