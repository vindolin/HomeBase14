// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import '/models/secrets_new.dart' as secrets;
import '/models/encryption.dart' as encryption;

void main(List<String> args) {
  // encrypt the secretsX

  // final iv = encrypt.IV.fromLength(8);
  final iv = encrypt.IV.fromBase64(encryption.iv);
  final key = encrypt.Key.fromUtf8(args[0]);

  final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));
  // convert secrets.secretsMap to json
  String secretsJson = jsonEncode(secrets.secretsMap);
  // print(secretsJson);
  // encrypt it
  final encrypted = encrypter.encrypt(secretsJson, iv: iv).base64;
  print(encrypted);
  // unencrypt
  // final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(encrypted), iv: iv);
  // Map<String, dynamic> decryptedMap = jsonDecode(decrypted);
  // print(decryptedMap);
  // dynamic x = (decryptedMap['local']['mqttPort']);
  // print the type of x
}
