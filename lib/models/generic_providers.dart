import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generic_providers.g.dart';

@riverpod
class Toggler extends _$Toggler {
  @override
  bool build(String key) => false;

  void toggle() => state = !state;
}

@riverpod
class Counter extends _$Counter {
  @override
  int build(String key) => 0;

  void increment() => state++;
}
