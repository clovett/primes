import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';
import 'package:primes/primes.dart';

void main() {
  runApp(MyApp());
}

class BackgroundWorker {
  int max;
  BackgroundWorker(this.max);

  void isolatedWorker(SendPort sendPort) {
    List<int> result = [];
    int progress = 0;
    var primes = Primes();
    for (var p in primes.compute(max)) {
      int actual = (primes.progress * 100).toInt();
      if (actual != progress) {
        sendPort.send(actual);
        progress = actual;
      }
      result.add(p);
    }
    sendPort.send(result);
  }
}

class PrimeState {
  int max = 1000;
  List<int> result = [];
  bool complete = false;
  double progress = 0;
  Function? notifyChanged;

  void setProgress(double p) {
    progress = p;
    if (notifyChanged != null) {
      notifyChanged!();
    }
  }

  void begin(max) async {
    print("beginning...");
    this.max = max;
    complete = false;
    result = [];

    await for (var p in runWithProgress()) {
      setProgress(p / 100.0);
      if (complete) {
        finish();
        break;
      }
    }
  }

  void finish() {
    print("finished.");
    setProgress(1);
  }

  Stream<int> runWithProgress() async* {
    var receivePort = ReceivePort();
    BackgroundWorker worker = BackgroundWorker(max);
    Isolate.spawn(worker.isolatedWorker, receivePort.sendPort);
    await for (var msg in receivePort) {
      if (msg is int) {
        yield msg;
      } else if (msg is List<int>) {
        result = msg;
        complete = true;
        yield 100;
        break;
      }
    }
  }
}

class MyApp extends StatelessWidget {
  PrimeState primes = PrimeState();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Isolate Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', primes: primes),
    );
  }
}

class MyHomePage extends StatefulWidget {
  late _MyHomePageState _state;

  MyHomePage({super.key, required this.title, required this.primes});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  final PrimeState primes;

  @override
  State<MyHomePage> createState() => _MyHomePageState(primes);
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _value = 0;
  PrimeState primes;

  _MyHomePageState(this.primes) {
    primes.notifyChanged = () {
      setState(() {
        _value = primes.progress;
      });
    };
  }

  void onButtonClick() {
    primes.begin(primes.max * 10);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Click the button to start the computation...',
            ),
            Text(
              primes.complete
                  ? 'found ${primes.result.length} primes under ${primes.max}'
                  : 'computing primes up to ${primes.max}...',
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _value > 0
                    ? LinearProgressIndicator(
                        value: _value,
                        semanticsLabel: 'Primes progress indicator',
                      )
                    : null),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onButtonClick,
        tooltip: 'Start',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
