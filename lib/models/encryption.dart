import 'package:encrypt/encrypt.dart';

const ivString = '4ygMAg7aRyw=';
final iv = IV.fromBase64(ivString);

Encrypter getEncrypter(String key) {
  return Encrypter(
    Salsa20(
      Key.fromUtf8(key),
    ),
  );
}

String decrypt(String key, String encrypted) {
  return getEncrypter(key).decrypt(
    Encrypted.fromBase64(encrypted),
    iv: iv,
  );
}

String encrypt(String key, String input) {
  return getEncrypter(key)
      .encrypt(
        input,
        iv: iv,
      )
      .base64;
}

bool testEncryption(String key, String encrypted, String decrypted) {
  return decrypt(key, encrypted) == decrypted;
}
