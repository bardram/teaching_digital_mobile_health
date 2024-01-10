import 'package:flutter/material.dart';

void main() => runApp(const FutureBuilderExampleApp());

class FutureBuilderExampleApp extends StatelessWidget {
  const FutureBuilderExampleApp({super.key});

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(home: FutureBuilderExample());
}

class FutureBuilderExample extends StatefulWidget {
  const FutureBuilderExample({super.key});

  @override
  State<FutureBuilderExample> createState() => _FutureBuilderExampleState();
}

class _FutureBuilderExampleState extends State<FutureBuilderExample> {
  final Future<String> loadData =
      Future<String>.delayed(const Duration(seconds: 4), () => 'Data Loaded'
          // Future<String>.error('An Error Occurred....'),
          );

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
        style: TextStyle(color: Colors.white.withOpacity(1.0), fontSize: 30),
        textAlign: TextAlign.center,
        child: FutureBuilder<String>(
          future: loadData,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                const Icon(Icons.check_circle_outline,
                    color: Colors.green, size: 60),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Result: ${snapshot.data}'),
                ),
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                ),
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          },
        ),
      );
}
