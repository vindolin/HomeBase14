import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'open_connection_data_form_provider.g.dart';

@Riverpod(keepAlive: true)
class OpenConnectionDataForm extends _$OpenConnectionDataForm {
  @override
  bool build() {
    return false;
  }

  void set(bool value) {
    state = value;
  }
}
