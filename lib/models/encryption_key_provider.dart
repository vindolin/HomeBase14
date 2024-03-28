import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encryption_key_provider.g.dart';

@Riverpod(keepAlive: true)
class EncryptionKey extends _$EncryptionKey {
  @override
  String? build() {
    return null;
  }

  void setEncryptionKey(String encryptionKey) {
    state = encryptionKey;
  }
}
