typedef DataList = List<int>;

void main() {
  DataList data = [50, 60];
  data.add(100);
  print('length: ${data.length}');
  print('values: $data');
  print('type: ${data.runtimeType}');
}
