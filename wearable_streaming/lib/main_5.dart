// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:polar/polar.dart';
import 'package:mdsflutter/Mds.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const HRApp());

/// This HR Monitor is an extension of main_3.dart with support for using a
/// Movesense device in addition to the the Polar device.
///
/// This is done by;
///
/// * creating a super class [StatefulHRMonitor] which contain shared logic
/// * creating a specialized sub-class for a [PolarHRMonitor] and a [MovesenseHRMonitor]
///
/// The app also shows how to make a device controller, where support for both
/// Polar and Movesense is done in two separate classes - [MovesenseDeviceController]
/// and [PolarDeviceController].
///
/// Finally, the app shows how a HR monitor can be extended with other functions.
/// By extending the [MovesenseHRMonitor], the [MovesenseMonitor] class add more
/// functionality -- in this case, adding stream than on a regular basis collects
/// battery state and expose it in a stream.
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
  final HRMonitor monitor = MovesenseHRMonitor('0C:8C:DC:3F:B2:CD');

  @override
  void initState() {
    super.initState();
    monitor.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Heart Rate Monitor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<DeviceState>(
              stream: monitor.stateChange,
              builder: (context, snapshot) => Text(
                  'Device [${monitor.identifier}] - ${monitor.state.name}'),
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
  error,
}

/// A stateful Heart Rate (HR) Monitor where you can listen to
/// [stateChange] events.
abstract class StatefulHRMonitor implements HRMonitor {
  StreamSubscription<dynamic>? _subscription;

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
  Stream<int> get heartbeat => _controller.stream;

  @override
  @mustCallSuper
  Future<void> init() async {
    if (!(await hasPermissions)) await requestPermissions();
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

  /// Pause collection of HR data.
  void pause() => _subscription?.pause();

  /// Resume collection of HR data.
  void resume() => _subscription?.resume();

  @override
  @mustCallSuper
  void stop() {
    _subscription?.cancel();
    state = DeviceState.connected;
  }
}

/// A Polar Heart Rate (HR) Monitor.
class PolarHRMonitor extends StatefulHRMonitor {
  final polar = Polar();
  final String _identifier;

  PolarHRMonitor(this._identifier);

  @override
  String get identifier => _identifier;

  @override
  Future<void> init() async {
    await super.init();

    polar.batteryLevel.listen((e) => print('Battery: ${e.level}'));
    polar.deviceConnecting.listen((_) => state = DeviceState.connecting);
    polar.deviceConnected.listen((_) => state = DeviceState.connected);
    polar.deviceDisconnected.listen((_) => state = DeviceState.disconnected);

    state = DeviceState.initialized;
    await polar.connectToDevice(identifier);
  }

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
}

/// A Movesense Heart Rate (HR) Monitor.
class MovesenseHRMonitor extends StatefulHRMonitor {
  final String? _address, _name;
  String? _serial;

  @override
  String get identifier => _address!;

  /// The BLE address of the device.
  String get address => _address!;

  /// The name of the device.
  String? get serial => _serial;

  /// The serial number of the device.
  String? get name => _name;

  MovesenseHRMonitor(this._address, [this._name]);

  @override
  Future<void> init() async {
    state = DeviceState.initialized;
    await super.init();

    // Start connecting to the Movesense device with the specified address.
    state = DeviceState.connecting;
    Mds.connect(
      address,
      (serial) {
        _serial = serial;
        state = DeviceState.connected;
      },
      () => state = DeviceState.disconnected,
      () => state = DeviceState.error,
    );
  }

  @override
  @mustCallSuper
  void start() {
    if (state == DeviceState.connected && _serial != null) {
      _subscription = MdsAsync.subscribe(
              Mds.createSubscriptionUri(_serial!, "/Meas/HR"), "{}")
          .listen((event) {
        print('>> $event');
        num hr = event["Body"]["average"];
        _controller.add(hr.toInt());
      });
      state = DeviceState.sampling;
    }
  }

  /// Disconnect from the Movesense device.
  void disconnect() => Mds.disconnect(address);
}

enum BatteryState { low, normal }

/// A Movesense Monitor.
class MovesenseMonitor extends MovesenseHRMonitor {
  MovesenseMonitor(super.address, [super.name]);

  final StreamController<BatteryState> _batteryStateController =
      StreamController.broadcast();

  /// A stream of battery status for this Movesense device.
  Stream<BatteryState> get battery => _batteryStateController.stream;

  @override
  void start() {
    super.start();

    // Create a timer that asks for battery status on a regular basis.
    Timer.periodic(const Duration(seconds: 1), (timer) {
      MdsAsync.get(
        Mds.createSubscriptionUri(_serial!, "/System/States/1"),
        "{}",
      ).then((value) {
        print('>> $value');
        num binaryState = value["Body"]["content"];
        BatteryState state =
            (binaryState.toInt() == 1) ? BatteryState.normal : BatteryState.low;
        _batteryStateController.add(state);
      });
    });
  }
}

/// Controls a list of [devices] found during a [scan] operation.
abstract interface class DeviceController {
  /// The list of available monitors.
  List<HRMonitor> get devices;

  /// Is this controller scanning for devices?
  bool get isScanning;

  /// Start scanning for devices. Found devices are added to [devices].
  void scan();
}

/// A [DeviceController] handling [MovesenseHRMonitor] devices.
class MovesenseDeviceController implements DeviceController {
  final List<MovesenseHRMonitor> _devices = [];
  bool _isScanning = false;

  @override
  List<HRMonitor> get devices => _devices;

  @override
  bool get isScanning => _isScanning;

  @override
  void scan() {
    try {
      _isScanning = true;
      Timer(const Duration(seconds: 60), () => stopScan());
      Mds.startScan((name, address) {
        var device = MovesenseHRMonitor(address, name);
        print('Device found, address: $address');
        if (!devices.contains(device)) {
          devices.add(device);
        }
      });
    } on Error {
      print('Error during scanning');
    }
  }

  void stopScan() {
    _isScanning = false;
    Mds.stopScan();
  }
}

class PolarDeviceController implements DeviceController {
  final List<PolarHRMonitor> _devices = [];
  bool _isScanning = false;

  @override
  List<HRMonitor> get devices => _devices;

  @override
  bool get isScanning => _isScanning;

  @override
  void scan() {
    _isScanning = true;
    // TODO: implement scan
  }
}
