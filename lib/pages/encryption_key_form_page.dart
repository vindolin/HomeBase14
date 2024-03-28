import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mqtt5_client/mqtt5_client.dart';

import '/utils.dart';
import '/models/app_settings.dart';
import '/widgets/password_input_widget.dart';

// TODO catch the back action and return to the home page instead of exiting the app

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class EncryptionKeyFormPage extends ConsumerWidget {
  EncryptionKeyFormPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppSettingsCls appSettingsCls = ref.watch(appSettingsProvider);
    final Map<String, dynamic> formData = {
      'encryptionKey': appSettingsCls.encryptionKey,
    };

    log('login form build');

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

        final saveResult = appSettings.saveEncryptionKey(formData['encryptionKey']);
        // log(saveResult.toString());

        if (saveResult) {
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
        title: const Text('Decrypt Settings'),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          PasswordField(
            key: UniqueKey(),
            labelText: 'Encryption Key',
            initialValue: appSettingsCls.encryptionKey,
            onSaved: (String? value) {
              formData['encryptionKey'] = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please enter the encryption key';
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
