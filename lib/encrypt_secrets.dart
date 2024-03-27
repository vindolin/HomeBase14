// ignore_for_file: avoid_print
import 'dart:convert';

import '/models/secrets_new.dart' as secrets; // not in repo
import '/models/encryption.dart' as encryption;

const certKey = '''-----BEGIN RSA PRIVATE KEY-----

insert mqtt cert key here

-----END RSA PRIVATE KEY-----''';

void main(List<String> args) {
  final key = args[0];
  const payload = certKey;
  // String payload = jsonEncode(secrets.secretsMap);
  final encrypted = encryption.encrypt(key, payload);
  print(encrypted);
}
