// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import '/models/encryption.dart' as encryption;

void main(List<String> args) {
  // encrypt the secretsX

  final iv = encrypt.IV.fromBase64(encryption.iv);
  final key = encrypt.Key.fromUtf8(args[0]);
  final encrypted = args[1];
  final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));
  final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(encrypted), iv: iv);
  Map<String, dynamic> decryptedMap = jsonDecode(decrypted);
  print(decryptedMap);
}
