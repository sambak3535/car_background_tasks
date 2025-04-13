class Car {
  final String model;
  final int year;
  final String vehicleTag;

  Car({
    required this.model,
    required this.year,
    required this.vehicleTag,
  });

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'year': year,
      'vehicle_tag': vehicleTag,
      'timestamp': DateTime.now().millisecondsSinceEpoch, // for sorting
    };
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      model: json['model'],
      year: json['year'],
      vehicleTag: json['vehicle_tag'],
    );
  }
}
