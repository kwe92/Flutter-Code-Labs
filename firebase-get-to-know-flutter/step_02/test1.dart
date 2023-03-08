int main() {
  final String name;

  name = 'kwe';

  const List<Object> myList = [1, 2, 'Hello', <String, num>{}];

  final List<num> myList2 = List<Object>.from(myList).whereType<num>().toList();
  print(name);
  print(myList2);

  return 0;
}
