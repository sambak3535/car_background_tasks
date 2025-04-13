import 'package:carbackgroundtasks/model/car.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref("cars");

  Future<void> insertCar(Car car) async {
    await _db.push().set(car.toJson());
  }

  Future<Car?> getLastCar() async {
    final dbRef = FirebaseDatabase.instance.ref().child("background_cars");

    final snapshot = await dbRef.orderByChild("timestamp").limitToLast(1).get();

    if (snapshot.exists) {
      final values = Map<String, dynamic>.from(snapshot.value as Map);
      final carData = values.values.first;

      return Car(
        model: carData['model'],
        year: carData['year'],
        vehicleTag: carData['vehicle_tag'],
      );
    } else {
      return null;
    }
  }
}
