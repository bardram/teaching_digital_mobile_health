// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:polar/polar.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const HRApp());

/// This HRApp is the most simple version of a HR demo app, highlighting:
///
/// * using a simple HR monitor [SimplePolarHRMonitor]
/// * starting the monitor from the FloatingActionButton
/// * displaying HR data in a StreamBuilder
///
/// Note that the user has to wait pressing the "start" button until the
/// initialization has taken place, and that this isn't visible in the UI.
///
/// Also note that once the sampling has started, it cannot be stopped again.
class HRApp extends StatelessWidget {
  const HRApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: HRHomePage());
}

class HRHomePage extends StatefulWidget {
  const HRHomePage({super.key});

  @override
  State<HRHomePage> createState() => _HRHomePageState();
}

class _HRHomePageState extends State<HRHomePage> {
  final monitor = SimplePolarHRMonitor('B36B5B21');

  @override
  void initState() {
    super.initState();
    monitor.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polar HR Monitor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Polar - device id: ${monitor.identifier}'),
            const Text('Your heart rate is:'),
            StreamBuilder<int>(
                stream: monitor.heartbeat,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  var displayText = 'unknown';
                  if (snapshot.hasData) displayText = '${snapshot.data}';
                  return Text(
                    displayText,
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Start HR Monitor',
        child: const Icon(Icons.play_arrow),
        onPressed: () => monitor.start(),
      ),
    );
  }
}

/// The most basic Polar Heart Rate (HR) Monitor, supporting
///  * requesting permissions
///  * initialization of listeners
///  * connecting to Polar device
///  * listening to HR events
class SimplePolarHRMonitor {
  final _controller = StreamController<int>.broadcast();

  final polar = Polar();
  String identifier;

  SimplePolarHRMonitor(this.identifier);

  /// The stream of heartbeat measures from this HR monitor.
  Stream<int> get heartbeat => _controller.stream;

  /// Do we have the required Bluetooth permissions?
  Future<bool> get hasPermissions async =>
      await Permission.bluetoothScan.isGranted &&
      await Permission.bluetoothConnect.isGranted;

  /// Request the required Bluetooth permissions.
  Future<void> requestPermissions() async => await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

  /// Initialize this HR monitor.
  Future<void> init() async {
    if (!(await hasPermissions)) await requestPermissions();

    polar
        .searchForDevice()
        .listen((event) => print('Found device in scan: ${event.deviceId}'));

    // Listen for life cycle events
    polar.deviceConnecting.listen(
        (event) => print('Connecting to device - id:${event.deviceId}'));
    polar.deviceConnected.listen((event) => print('Device connected'));
    polar.deviceDisconnected.listen((event) => print('Device disconnected'));

    // Listen for device characteristics
    polar.batteryLevel.listen((event) => print('Battery: ${event.level}'));
    polar.blePowerState.listen((event) => print('BLE Power State is: $event'));
    polar.disInformation
        .listen((event) => print('Device DIS info: ${event.info}'));
    polar.sdkFeatureReady
        .listen((event) => print('Device SDK Feature: ${event.feature}'));

    print('Connecting to device, id: $identifier');
    await polar.connectToDevice(identifier);
  }

  /// Start this HR monitor.
  ///
  /// Even though the Polar `startHrStreaming` stream return a list of HR samples,
  /// the physical device always only return one HR sample. Hence, we can use the
  /// expression "event.samples.first.hr" to get the HR of the first sample.
  void start() {
    polar
        .startHrStreaming(identifier)
        .listen((PolarHrData event) => _controller.add(event.samples.first.hr));
  }
}
