import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

part 'generic_providers.g.dart';

@Riverpod(keepAlive: true)
class Toggler extends _$Toggler {
  @override
  bool build(String key) => false;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}

@Riverpod(keepAlive: true)
class Counter extends _$Counter {
  @override
  int build(String key) => 0;

  void increment() => state++;
}

@Riverpod(keepAlive: true)
class AppLog extends _$AppLog {
  @override
  IList<String> build() {
    return IList<String>();
  }

  void log(String message) {
    state = state.add(message);
  }
}
