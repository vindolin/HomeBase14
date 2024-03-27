import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'network_type_provider.g.dart';

const networkTypeLocal = 'local';
const networkTypeMobile = 'mobile';

@riverpod
class NetworkType extends _$NetworkType {
  @override
  String build() {
    return networkTypeMobile;
  }
}
