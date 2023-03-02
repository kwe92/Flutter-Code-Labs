void main() {
  num times2(num x) {
    final num result = x * 2;
    return result;
  }

  final map1 = {'func1': times2};
  print(map1['func1']!(3));
}
