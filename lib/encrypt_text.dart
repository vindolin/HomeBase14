// ignore_for_file: avoid_print

import '/models/encryption.dart' as encryption;

void main(List<String> args) {
  final [key, payload] = args;
  final encrypted = encryption.encrypt(key, payload);
  print(encrypted);
}
