void main(List<String> args) {
  Set set = {};
  set.add(0);
  set.add(1);
  set.add(0);

  print(set);
  print('length = ${set.length}');

  List<int> list = [1, 2, 3, 4, 1, 2, 3];
  print(list);
  list.contains(1);

  Set<int> set_2 = Set.from(list);
  print(set_2);

  print(set_2.contains(4));
  print(set_2.contains(5));

  List<int> list_2 = set_2.toList();
  print(list_2);

  Set<String> names = {'Jess', 'Jake', 'May', 'Amy'};
  set.addAll(names);
  print(set);
}
