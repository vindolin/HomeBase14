// //import 'dart:convert';

// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'models/secrets_new.dart' as secrets;

// void main(List<String> args) {
//   // encrypt the secretsX
//   final encrypter = encrypt.Encrypter(
//     encrypt.Salsa20(
//       encrypt.Key.fromUtf8(args[0]),
//     ),
//   );
//   // convert secrets.secretsMap to json
//   String secretsJson = jsonEncode(secrets.secretsMap);
//   // print(secretsJson);
//   // encrypt it
//   final encrypted = encrypter.encrypt(secretsJson, iv: encrypt.IV.fromBase64('4ygMAg7aRyw='));
//   print(encrypted.base64);
//   // // unencrypt
//   // final decrypted = encrypter.decrypt(encrypted, iv: encrypt.IV.fromBase64('4ygMAg7aRyw='));
//   // // decode json to map
//   // Map<String, dynamic> decryptedMap = jsonDecode(decrypted);

//   // dynamic x = (decryptedMap['local']['mqttPort']);
//   // print the type of x
// }
