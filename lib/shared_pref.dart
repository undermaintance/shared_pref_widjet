import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(storage: CounterStorage()),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter2.txt');
  }
  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
}

//

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //
  int _counter2 = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter2 = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter2++;
    });
    return widget.storage.writeCounter(_counter2);
  }
  //
  int _counter1 = 0;

  void inState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter1 = (prefs.getInt('counter') ?? 0);
    });
  }

  void _increment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter1 = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter1);
    });
  }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Загрузка и сохранение данных'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 300,
                child: TextField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFeceff1),
                    border: OutlineInputBorder(),
                    labelText: 'Введите имя',
                  ),
                ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _increment,
              child: const Text('ПЕРВАЯ КНОПКА'),
            ),
            const SizedBox(height: 10),
            Text(
              'Нажатий: $_counter1', style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('ВТОРАЯ КНОПКА'),
            ),
            const SizedBox(height: 10),
            Text(
              'Нажатий: $_counter2', style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}