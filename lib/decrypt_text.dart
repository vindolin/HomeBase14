// ignore_for_file: avoid_print
import '/models/encryption.dart' as encryption;

void main(List<String> args) {
  // encrypt the secretsX
  final [key, encrypted] = args;
  final decrypted = encryption.decrypt(key, encrypted);
  print(decrypted);
}
