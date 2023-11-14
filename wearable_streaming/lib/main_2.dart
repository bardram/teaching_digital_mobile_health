// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:polar/polar.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const HRApp());

/// This is a slightly more advance HR Monitor (compared to main_1.dart), featuring:
///
/// * defining an interface for a [HRMonitor]
/// * an implementation done as a [PolarHRMonitor]
/// * keeping track on device state in the enum [DeviceState]
/// * also supporting "stopping" the monitor from the FloatingActionButton
/// * the icon of the button is updated according to the state of the device
/// * displaying device states in the UI.
///
/// Note that since the PolarHRMonitor knows its own connection state,
/// we can avoid starting sampling before the device is actually connected. See
/// the "start" method.
///
/// Note that this implementation still has the problem that the user needs to
/// wait until the init method has run before pressing "start".
///
/// Also note that the state of the device isn't updated correctly in the UI, and
/// that update of the UI has to take place in a "setState()" Widget methods -
/// which is bad coding :-(
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
  final HRMonitor monitor = PolarHRMonitor('B36B5B21');

  @override
  void initState() {
    super.initState();
    monitor.init();
  }

  void startOrStopHRMonitor() {
    // This call to setState tells the Flutter framework that something has
    // changed in this State, which causes it to rerun the build method below
    // so that the display can reflect the updated values.
    //
    // Note that this is ONLY used to rebuild the FloatingActionButton below and
    // NOT for displaying the heart rate. Displaying the heart rate number
    // is done using a StreamBuilder, which is always update when the stream emits
    // a new value.
    //
    // Hence, if you build your app using only StreamBuilder (and other reactive)
    // Widgets, then there is not need to use these ugly "setState()" calls.
    setState(() {
      if (monitor.isRunning) {
        monitor.stop();
      } else {
        monitor.start();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polar HR Monitor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Polar [${monitor.identifier}] - ${monitor.state.name}'),
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
        onPressed: startOrStopHRMonitor,
        tooltip: 'Start/Stop HR Monitor',
        // Set the icon of the button to reflect if the HR monitor can be
        // started or stopped
        child: (monitor.isRunning)
            ? const Icon(Icons.stop)
            : const Icon(Icons.play_arrow),
      ),
    );
  }
}

/// A Heart Rate (HR) Monitor interface.
///
/// The [heartbeat] stream emits heart rate events as [int].
/// Can be started and stopped via the [start] and [stop] commands.
abstract class HRMonitor {
  /// The identifier of this monitor.
  String get identifier;

  /// The state of this monitor.
  DeviceState get state;

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

/// A Polar Heart Rate (HR) Monitor.
class PolarHRMonitor implements HRMonitor {
  final _controller = StreamController<int>.broadcast();
  StreamSubscription<PolarHrData>? _subscription;
  final polar = Polar();

  @override
  String identifier;

  @override
  DeviceState state = DeviceState.unknown;

  PolarHRMonitor(this.identifier);

  @override
  Stream<int> get heartbeat => _controller.stream;

  @override
  Future<void> init() async {
    if (!(await hasPermissions)) await requestPermissions();

    polar.batteryLevel.listen((e) => print('Battery: ${e.level}'));

    polar.deviceConnecting.listen((_) {
      state = DeviceState.connecting;
      print('Device connecting');
    });
    polar.deviceConnected.listen((_) {
      state = DeviceState.connected;
      print('Device connected');
    });
    polar.deviceDisconnected.listen((_) {
      state = DeviceState.disconnected;
      print('Device disconnected');
    });

    state = DeviceState.initialized;

    print('Connecting to device: $identifier');
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
        print(event);
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
