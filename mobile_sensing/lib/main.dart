import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const SensorApp());

class SensorApp extends StatelessWidget {
  const SensorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Sensing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SensorsPage(),
    );
  }
}

class SensorsPage extends StatefulWidget {
  const SensorsPage({super.key});

  @override
  State<SensorsPage> createState() => SensorsPageState();
}

/// Shows a list of sensors in a ListView.
class SensorsPageState extends State<SensorsPage> {
  /// The list of sensors to be shown in the app.
  final List<Sensor> sensors = [];

  @override
  void initState() {
    // Add the different sensors to the list of sensors.
    //
    // In this skeleton app, we only have a MockSensor, so this
    // is added a couple of times. But in a full mobile sensing
    // app, this list would contain all the sensors listed in
    // the SensorType enumeration.
    sensors.add(MockSensor());
    sensors.add(MockSensor());
    sensors.add(MockSensor());
    sensors.add(MockSensor());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Sensing')),
      body: ListView.builder(
        padding: const EdgeInsets.all(5.5),
        itemCount: sensors.length,
        itemBuilder: sensorCard,
      ),
    );
  }

  /// Create the sensor card showing the sensor's icon and name,
  /// and showing sensor data from the "reading" stream using
  /// a StreamBuilder.
  ///
  /// The sensor can be started and stopped by clicking the card,
  /// which is handled in the "onPressed" method.
  Widget sensorCard(BuildContext context, int index) {
    var sensor = sensors[index];
    return Card(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          icon: Icon(sensor.icon, size: 24.0),
          label: StreamBuilder(
              stream: sensor.readings,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                var displayText = sensor.name;
                if (snapshot.hasData) displayText += '\n${snapshot.data}';
                return Text(displayText);
              }),
          onPressed: () {
            setState(() {
              if (sensor.isRunning) {
                sensor.stop();
              } else {
                sensor.start();
              }
            });
          },
        ),
      ),
    );
  }
}

/// Different types of available sensors.
enum SensorType {
  mock,
  accelerometer,
  gyroscope,
  magnetometer,
  location,
  light,
  pedometer,
}

/// A definition of a sensor.
abstract interface class Sensor {
  /// The type of sensor.
  SensorType get type;

  /// An icon illustrating this sensor.
  IconData get icon;

  /// The name of the sensor.
  String get name;

  /// Is this sensor running, i.e., started?
  bool get isRunning;

  /// The stream of sensor readings as a string representation.
  Stream<String> get readings;

  /// Start this sensor.
  void start();

  /// Stop this sensor.
  void stop();
}

/// A simple mock sensor that "collects" random mock data.
///
/// Useful for testing the UI in an emulator.
class MockSensor implements Sensor {
  final _controller = StreamController<String>.broadcast();
  final _random = Random();
  Timer? _timer;
  bool _isRunning = false;

  @override
  bool get isRunning => _isRunning;

  @override
  SensorType get type => SensorType.mock;

  @override
  IconData get icon => Icons.sensors_off;

  @override
  String get name => 'Mock Sensor';

  @override
  Stream<String> get readings => _controller.stream;

  @override
  void start() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      _controller.sink.add(_random.nextInt(100).toString());
    });
    _isRunning = true;
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }
}
