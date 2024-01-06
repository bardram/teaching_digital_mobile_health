import 'dart:async';
import 'dart:math';

void main(List<String> args) {
  Stream<int> monitor = Stream.empty();

  var hrValues = [50, 53, 56, 58, 65, 54, 67, 55];
  monitor = Stream.fromIterable(hrValues);
  monitor.listen((hr) => print('HR: $hr'));

  monitor = Stream.fromFuture(Future.delayed(Duration(seconds: 5), () => 189));
  monitor.listen((hr) => print('Future HR: $hr'));

  monitor = Stream.periodic(Duration(seconds: 1), (count) => 52 + count);
  monitor.listen((hr) => print('BPM: $hr'));

  // var subscription = monitor.listen((hr) => print('HR: $hr'));

  // Future.delayed(Duration(seconds: 4), () => subscription.pause());
  // Future.delayed(Duration(seconds: 8), () => subscription.resume());
  // Future.delayed(Duration(seconds: 16), () => subscription.cancel());

  // simpleHRMonitor.listen(
  //   (hr) {
  //     print('HR: $hr');
  //   },
  //   onError: (err) {
  //     print('Error!');
  //   },
  //   cancelOnError: false,
  //   onDone: () {
  //     print('Done!');
  //   },
  // );

  // var subscription = simpleHRMonitor.listen((hr) {
  //   print('HR: $hr');
  // });

  // Future.delayed(Duration(seconds: 4), () => subscription.pause());
  // Future.delayed(Duration(seconds: 5), () => subscription.resume());
  // Future.delayed(Duration(seconds: 8), () => subscription.cancel());

  // var subscription = HRMonitor().heartrate.listen((hr) {
  //   print('HR: $hr');
  // });

  // HRMonitor().heartrate.distinct().listen((hr) => print('HR: $hr'));

  // int secondsPerMinute = 60;
  // int bpm = 0;
  // HRMonitor()
  //     .heartrate
  //     .take(secondsPerMinute)
  //     .forEach((hr) => bpm += hr)
  //     .then((value) {
  //   bpm = bpm ~/ secondsPerMinute;
  //   print('BPM: $bpm');
  // });

  // HRMonitor()
  //     .heartrate
  //     .map((hr) => (DateTime.now().millisecondsSinceEpoch, hr))
  //     .listen((sample) => print(sample));

  // Map<int, int> samples = {};

  // HRMonitor()
  //     .heartrate
  //     .map((hr) => (DateTime.now().millisecondsSinceEpoch, hr))
  //     .listen((sample) => samples[sample.$1] = sample.$2)
  //     .onData((data) => print(data));

  // var monitor = AdvancedHRMonitor();

  // monitor.heartrate.listen(
  //   (hr) => print(hr),
  //   onDone: () => print("Monitor disposed..."),
  // );
  // monitor.start();
  // Future.delayed(Duration(seconds: 10), () => monitor.stop());
  // Future.delayed(Duration(seconds: 13), () => monitor.start());
  // Future.delayed(Duration(seconds: 16), () => monitor.dispose());
}

class HRMonitor {
  Stream<int> get heartrate =>
      Stream.periodic(Duration(seconds: 1), (count) => 52 + count)
          .asBroadcastStream();
}

class AdvancedHRMonitor {
  final StreamController<int> controller = StreamController.broadcast();
  Timer? timer;
  final random = Random();
  Stream<int> get heartrate => controller.stream;

  void start() {
    timer ??= Timer.periodic(Duration(seconds: 1), (_) {
      if (!controller.isClosed) {
        controller.add(random.nextInt(150) + 50);
      }
    });
  }

  void stop() {
    timer?.cancel();
    timer = null;
  }

  void dispose() => controller.close();
}
