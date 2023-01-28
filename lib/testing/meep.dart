typedef CompareFn<A, B> = int Function(A a, B b);

// List<T> sortByList<T>(List<T> list, List<CompareFn> compareFns) {

List sortByList(List list, List<CompareFn> compareFns) {
  for (final compareFn in compareFns) {
    list.sort(compareFn);
  }
  return list;
}

void main() {
  List<int> numlist = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<String> charlist = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'];

  print(
    sortByList(
      numlist,
      [
        (a, b) => b.compareTo(a),
        (a, b) {
          return a % 2;
        },
      ],
    ),
  );

  print(
    sortByList(
      charlist,
      [
        (a, b) => b.compareTo(a),
      ],
    ),
  );
}
