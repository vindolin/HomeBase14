import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generic_providers.g.dart';

@riverpod
class Toggler extends _$Toggler {
  @override
  bool build() => false;
  void toggle() => state = !state;
}
