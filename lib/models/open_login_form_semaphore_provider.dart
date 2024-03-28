import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'open_login_form_semaphore_provider.g.dart';

@riverpod
class OpenLoginFormSemaphore extends _$OpenLoginFormSemaphore {
  @override
  bool build() {
    return false;
  }

  void set(bool value) {
    state = value;
  }
}
