import 'utils.dart';

typedef DataList = List<int>;

void main() {
  DataList data = [50, 60];
  data.add(100);
  log('length: ${data.length}');
  log('values: $data');
  log('type: ${data.runtimeType}');
}
