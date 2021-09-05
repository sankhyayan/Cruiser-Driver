import 'package:firebase_database/firebase_database.dart';

class DriverDataFromSnapshot {
  String? id = "",
      email = "",
      name = "",
      phone = "",
      car_color = "",
      car_model = "",
      car_number = "";
  DriverDataFromSnapshot(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.car_color,
      this.car_model,
      this.car_number});
  DriverDataFromSnapshot.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    phone = dataSnapshot.value["phone"];
    car_color = dataSnapshot.value["car_details"]["car_color"];
    car_model = dataSnapshot.value["car_details"]["car_model"];
    car_number = dataSnapshot.value["car_details"]["car_number"];
  }
}
