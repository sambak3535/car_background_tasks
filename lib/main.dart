import 'package:carbackgroundtasks/firebase_options.dart';
import 'package:carbackgroundtasks/model/car.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'services/firebase_service.dart';
import 'dart:async';
import 'dart:isolate';
import 'package:firebase_database/firebase_database.dart';

Future<void> carIsolate(SendPort sendPort) async {
  // Ensure platform channels are initialized in the isolate
  if (RootIsolateToken.instance != null) {
    BackgroundIsolateBinaryMessenger.ensureInitialized(
      RootIsolateToken.instance!,
    );
  } else {
    // Handle error or fallback if RootIsolateToken is not initialized
    print('RootIsolateToken is null. Cannot initialize platform channels.');
    return;
  }

  // Firebase initialization (necessary inside isolate)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final dbRef = FirebaseDatabase.instance.ref().child("background_cars");

  final newCar = {
    "model": "Tesla Isolate",
    "year": 2026,
    "vehicle_tag": "ISO-001",
    "timestamp": DateTime.now().millisecondsSinceEpoch,
  };

  // Insert the new car
  await dbRef.push().set(newCar);

  // Retrieve last inserted car
  final snapshot = await dbRef.orderByChild("timestamp").limitToLast(1).get();

  String lastCarText = "No car found";

  if (snapshot.exists) {
    final values = Map<String, dynamic>.from(snapshot.value as Map);
    final carData = values.values.first;

    lastCarText =
        "${carData['model']}, ${carData['year']}, ${carData['vehicle_tag']}";
  }

  // Send the result back to UI
  sendPort.send(lastCarText);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Car Firebase Test', home: CarHomePage());
  }
}

class CarHomePage extends StatefulWidget {
  const CarHomePage({super.key});

  @override
  State<CarHomePage> createState() => _CarHomePageState();
}

class _CarHomePageState extends State<CarHomePage> {
  final FirebaseService _firebaseService = FirebaseService();
  final platform = MethodChannel('com.example.carbackgroundtasks/workmanager');

  String _lastCar = "No data yet";

  Future<void> _insertCar() async {
    final car = Car(model: "Tesla Model S", year: 2024, vehicleTag: "TSLA-001");

    await _firebaseService.insertCar(car);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Inserted Car')));
  }

  Future<void> _getLastCar() async {
    final car = await _firebaseService.getLastCar();

    if (car != null) {
      setState(() {
        _lastCar = "${car.model}, ${car.year}, ${car.vehicleTag}";
      });
    } else {
      setState(() {
        _lastCar = "No car found";
      });
    }
  }

  Future<void> _startBackgroundTask() async {
    try {
      final String result = await platform.invokeMethod('startWorkManager');
      print("Background Task Triggered: $result");
    } catch (e) {
      print("Failed to start background task: $e");
    }
  }

  Future<void> _runIsolateTask() async {
    final receivePort = ReceivePort();

    await Isolate.spawn(carIsolate, receivePort.sendPort);

    final result = await receivePort.first;

    setState(() {
      _lastCar = "From Isolate: $result";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Car Firebase Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Manual Firebase Test:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _insertCar,
                    child: const Text("Insert Car"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _getLastCar,
                    child: const Text("Get Last Car"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              "Background Tasks:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _startBackgroundTask,
                    child: const Text("Start WorkManager"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _runIsolateTask,
                    child: const Text("Run Isolate Task"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              "Last Car Data:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_lastCar, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
