class SimpleWatch {
  Set<PushButton> buttons = {PushButton(), PushButton()};
  Display display = Display();
  Set<Battery> batteries = {Battery(), Battery()};
  Time time = Time();
}

class PushButton {}

class Display {}

class Battery {}

class Time {}

class Watch {
  Time time = Time();
  var date;

  void setDate(var d) => date = d;
}

class CalculatorWatch extends Watch {
  var calculatorState;

  void enterCalcMode() {}
  void inputNumber(int n) {}
}

abstract interface class OrganicCompound {}

class Benzene implements OrganicCompound {}
