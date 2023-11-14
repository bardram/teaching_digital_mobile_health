// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:polar/polar.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const HRApp());

/// This is the most advanced HR Monitor app solving some of the issues with
/// main_1.dart and main_2.dart. This app:
///
///  * uses a [StatefulPolarHRMonitor] which has a stream of [stateChange]
///  * this stateChange stream is used to keep the UI updated according to the
///    state of the monitor
///  * this also includes which icon to show on the button
///  * this allows us to AVOID USING the setState() Flutter method :-)
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
  final HRMonitor monitor = StatefulPolarHRMonitor('B36B5B21');

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
            StreamBuilder<DeviceState>(
              stream: monitor.stateChange,
              builder: (context, snapshot) =>
                  Text('Polar [${monitor.identifier}] - ${monitor.state.name}'),
            ),
            const Text('Your heart rate is:'),
            StreamBuilder<int>(
                stream: monitor.heartbeat,
                builder: (context, snapshot) {
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
        onPressed: () {
          if (monitor.isRunning) {
            monitor.stop();
          } else {
            monitor.start();
          }
        },
        tooltip: 'Start/Stop HR Monitor',
        child: StreamBuilder<DeviceState>(
          stream: monitor.stateChange,
          builder: (context, snapshot) => (monitor.isRunning)
              ? const Icon(Icons.stop)
              : const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}

/// A Heart Rate (HR) Monitor interface.
///
/// The [stateChange] streams state changes of this monitor.
/// The [heartbeat] stream emits heart rate events as [int].
/// Can be started and stopped via the [start] and [stop] commands.
abstract class HRMonitor {
  /// The identifier of this monitor.
  String get identifier;

  /// The state of this monitor.
  DeviceState get state;

  /// The stream of state changes of this monitor.
  Stream<DeviceState> get stateChange;

  /// The stream of heartbeat measures from this HR monitor.
  Stream<int> get heartbeat;

  /// Has this monitor been started via the [start] command?
  bool get isRunning;

  /// Initialize this HR monitor.
  Future<void> init();

  /// Start this HR monitor.
  void start();

  /// Stop this HR monitor.
  void stop();
}

/// An enumeration of know device states.
enum DeviceState {
  unknown,
  initialized,
  connecting,
  connected,
  sampling,
  disconnected,
}

/// A stateful Polar Heart Rate (HR) Monitor where you can listen to
/// [stateChange] events.
class StatefulPolarHRMonitor implements HRMonitor {
  StreamSubscription<PolarHrData>? _subscription;
  final String _identifier;
  final polar = Polar();

  // The follow code controls the state management and stream of state changes.
  final _controller = StreamController<int>.broadcast();

  final StreamController<DeviceState> _stateChangeController =
      StreamController.broadcast();
  DeviceState _state = DeviceState.unknown;

  set state(DeviceState state) {
    print('The device with id $identifier is ${state.name}.');
    _state = state;
    _stateChangeController.add(state);
  }

  @override
  DeviceState get state => _state;

  @override
  Stream<DeviceState> get stateChange => _stateChangeController.stream;

  @override
  String get identifier => _identifier;

  @override
  Stream<int> get heartbeat => _controller.stream;

  StatefulPolarHRMonitor(this._identifier);

  @override
  Future<void> init() async {
    if (!(await hasPermissions)) await requestPermissions();

    polar.batteryLevel.listen((e) => print('Battery: ${e.level}'));
    polar.deviceConnecting.listen((_) => state = DeviceState.connecting);
    polar.deviceConnected.listen((_) => state = DeviceState.connected);
    polar.deviceDisconnected.listen((_) => state = DeviceState.disconnected);

    state = DeviceState.initialized;
    await polar.connectToDevice(identifier);
  }

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

  @override
  bool get isRunning => state == DeviceState.sampling;

  @override
  void start() {
    if (state == DeviceState.connected) {
      _subscription =
          polar.startHrStreaming(identifier).listen((PolarHrData event) {
        _controller.add(event.samples.first.hr);
      });
      state = DeviceState.sampling;
    }
  }

  @override
  void stop() {
    _subscription?.cancel();
    state = DeviceState.connected;
  }
}
