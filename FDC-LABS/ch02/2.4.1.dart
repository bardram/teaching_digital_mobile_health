void main() {
  int weekday = 6;

  String whatToSay = switch (weekday) {
    1 => 'Monday',
    2 => 'Tuesday',
    6 || 7 => 'Enjoy the weekend!',
    _ => 'Error: Value not defined?',
  };

  print(whatToSay);
}
