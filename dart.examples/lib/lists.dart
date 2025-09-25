void main() {
  List letters = ['A', 'B', 'C', 'D', 'E', 'F'];
  print(letters);

  letters.forEach(print);

  print('length = ${letters.length}');

  for (var i = 0; i < letters.length; i++) {
    print('letters[$i] : ${letters[i]}');
  }

  letters[0] = 'AA';
  print(letters);

  List moreLetters = ['G', 'H', 'I', 'J', 'K', 'L'];

  letters.addAll(moreLetters);
  print('length = ${letters.length}');

  List numbers = [1, 2, 3, 4, 5];

  letters.addAll(numbers);
  print(letters);

  for (var i = 0; i < letters.length; i++) {
    print('letters[$i] : ${letters[i]}');
  }

  List<String> months = ['January', 'February', 'March', 'April', 'May'];
  print(months);

  List<int> realNumbers = [1, 2, 3, 4, 5, 1];

  var total = 0;
  realNumbers.forEach((element) {
    total = total + element;
  });

  numbers.forEach((element) {
    print(int.tryParse(element.toString()));
  });

  // this is not valid since 'numbers' do not contain Strings.
  // months.addAll(realNumbers);

  numbers.addAll(months);

  List<int> monthNumbers = [1, 2, 3, 4, 5];

  monthNumbers.map((month) => months[month]).forEach(print);
  monthNumbers.map((month) => months[month - 1]).forEach(print);

  List<Car> cars = [
    Car('S-model', 'Tesla', 2022),
    Car('A3', 'Audi', 2008),
  ];

  cars.reversed.forEach((car) => print(car.brand));
}

class Car {
  String model;
  String brand;
  int year;
  Car(this.model, this.brand, this.year);
}
