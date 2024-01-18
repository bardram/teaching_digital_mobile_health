class RobustDevice {
  String address = 'B36B5B21';
  void connect() {
    try {
      // trying to connect to a device
    } catch (error) {
      throw DeviceException(
          'Error during connect to device - error: $error', address);
    }
  }
}

class DeviceException implements Exception {
  String message;
  String address;

  DeviceException(this.message, this.address);

  @override
  String toString() => '$runtimeType - $message, device address: $address';
}

void main(List<String> args) {
  var device = RobustDevice();

  try {
    device.connect();
  } on DeviceException catch (exception) {
    print('wrong address: ${exception.address}');
    // handle device exception...
  } catch (exception) {
    // any other exception...
  } finally {
    // will always be done
  }
}
