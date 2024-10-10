// ignore_for_file: avoid_print
// import 'dart:io';
import 'dart:convert';
import 'dart:io';

import '/models/secrets_new.dart' as secrets; // not in repo
import '/models/encryption.dart' as encryption;

void main(List<String> args) {
  // File('..\\mqtt_cert_key.txt').readAsString().then((String certKey) {
  //   print(certKey);
  // });
  // const payload = certKey;

  final key = args[0];
  String payload = jsonEncode(secrets.secretsMap);
  final encrypted = encryption.encrypt(key, payload);
  // print(encrypted);

  final filePath = 'lib/models/secrets_provider.dart';
  final file = File(filePath);

  // open the file secrets_provider.dart and replace the _encryptedSecrets with the output of this script
  file.readAsString().then(
    (String contents) {
      final newContents = contents.replaceFirst(
        RegExp(r"(?<=final _encryptedSecrets \=)\n\s{6}r\'(.+)\';$", multiLine: true),
        '\n      r\'$encrypted\';',
      );
      file.writeAsString(newContents);
    },
  );
}
