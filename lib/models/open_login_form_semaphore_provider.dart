import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'open_login_form_semaphore_provider.g.dart';

@Riverpod(keepAlive: true)
class OpenLoginFormSemaphore extends _$OpenLoginFormSemaphore {
  @override
  bool build() {
    return true;
  }

  void set(bool value) {
    state = value;
  }
}
