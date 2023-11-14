void main(List<String> args) {
  Map<String, int> telephoneBook = {};
  telephoneBook['Jess'] = 3032222;
  telephoneBook['Jake'] = 511111;
  telephoneBook['May'] = 2111234;
  telephoneBook['Amy'] = 2225555;

  print(telephoneBook);

  telephoneBook.entries.forEach(print);
  telephoneBook.keys.forEach(print);
  telephoneBook.values.forEach(print);

  print(telephoneBook.containsKey('Jess'));

  telephoneBook.remove('Jess');
  print(telephoneBook);
  print(telephoneBook.containsKey('Jess'));

  Map<String, int> telephoneBook_2 = {
    'Jakob': 29550426,
    'Peter': 23458923,
  };
  telephoneBook.addAll(telephoneBook_2);
  print(telephoneBook);

  Map<String, String> telephoneBook_3 = {};
  telephoneBook_3['Jess'] = '303 2222';
  telephoneBook_3['Jake'] = '511 111';
  telephoneBook_3['May'] = '211 1234';
  telephoneBook_3['Amy'] = '222 5555';

  print(telephoneBook_3);

  // This is not valid, since telephoneBook_3 is a Map<String, String> and
  // telephoneBook is a Map<String, int>
  // telephoneBook.addAll(telephoneBook_3);
}
