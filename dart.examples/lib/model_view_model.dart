import 'dart:async';

class HRMonitor {
  Stream<int> get heartrate =>
      Stream.periodic(Duration(seconds: 1), (count) => 52 + count)
          .asBroadcastStream();
}

// --------------------------------
//                MODEL
// --------------------------------

/// A BLE Device (e.g., Movesense).
class Device {
  String identifier;
  String? bleId;
  String? name;
  DeviceState state = DeviceState.unknown;
  final monitor = HRMonitor();

  Device({required this.identifier, this.name, this.bleId});
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

// --------------------------------
//             VIEW MODEL
// --------------------------------

/// A ViewModel for [Device].
class DeviceViewModel {
  final Device device;
  DeviceViewModel(this.device);

  String get deviceName => device.name ?? 'Unknown';
  Stream<int> get heartrate => device.monitor.heartrate;

  DeviceState get state => device.state;

  set state(DeviceState state) {
    print('The device with id $device is ${state.name}.');
    device.state = state;
    _stateChangeController.add(state);
  }

  final StreamController<DeviceState> _stateChangeController =
      StreamController.broadcast();
  Stream<DeviceState> get stateChange => _stateChangeController.stream;
}
