class Employee {
  int id;
  String name;
  String department;
  DateTime? hired = null;

  bool get isHired => hired != null;

  Employee(this.id, this.name, this.department);

  void hire() => hired = DateTime.now();

  void fire() => hired = null;

  @override
  String toString() =>
      'ID: $id. name: $name, department: $department, hired: $isHired';
}

class Manager extends Employee {
  List<Employee> employees = [];

  int get headCount => employees.length;

  Manager(super.id, super.name, super.department);

  void hireEmployee(Employee employee) {
    employee.hire();
    employee.department = this.department;
    employees.add(employee);
  }

  void fireEmployee(Employee employee) {
    employee.fire();
    employee.department = 'unknown';
    employees.remove(employee);
  }

  @override
  String toString() => '${super.toString()}, employees: $employees';
}

class Executive extends Manager {
  Executive(super.id, super.name, super.department);
}

void main(List<String> args) {
  // Example of using plain classes and inheritance

  var e1 = Employee(1, 'Alex', 'Accounting');
  var e2 = new Employee(2, 'Benjamin', 'Engineering');
  var e3 = new Employee(3, 'Christian', 'HR');
  var e4 = Employee(4, 'Dorthe', 'Engineering');

  print(e1.toString());

  var manager = new Manager(99, 'Ole Hanson', 'Engineering');
  manager.hire();
  manager.hireEmployee(e1);
  manager.hireEmployee(e3);

  print('Manager: $manager\n');
  print(manager.headCount);

  var ceo = Executive(999, 'Hans Gunnarson', 'Executive Management Group');
  ceo.hireEmployee(manager);
  ceo.fire();

  List<Employee> company = [];
  company.add(e3);
  company.add(ceo);

  company[0].hire();

  print('CEO: $ceo\n');

  // Example of using interface classes

  Map<String, Sensor> sensors = {};
  sensors['B36B5B21'] = PolarSensor('H10', 'READY');
  sensors['B36B5421'] = PolarSensor('H10', 'READY');
  sensors['B36B5721'] = PolarSensor('PVS', 'READY');

  sensors.forEach((key, sensor) => sensor.start());

  print(sensors);
}

/// A definition of a sensor.
abstract interface class Sensor {
  /// The type of sensor.
  String get type;

  /// The runtime status of this sensor.
  String get status;

  /// The stream of sensor readings.
  Stream<dynamic> get readings;

  /// Start this sensor.
  void start();

  /// Stop this sensor.
  void stop();
}

class PolarSensor implements Sensor {
  String type;
  String status;
  Stream get readings => Stream.empty();

  PolarSensor(this.type, this.status);

  void start() {
    print('Starting $type....');
    status = "STARTED";
  }

  void stop() {
    print('Stopping $type....');
    status = "STOPPED";
  }

  String toString() => 'Polar - type: $type, status: $status';
}
