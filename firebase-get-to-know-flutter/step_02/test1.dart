void main() {
  num times2(num x) => x * 2;

  final myMap = {times2: times2};

  final Map<String, num Function(num)> map1 = {'func1': times2};
  final _times2 = map1['func1'] as num Function(num);
  print(_times2(3));
}
