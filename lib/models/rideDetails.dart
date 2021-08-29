import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails {
  String? pickup_address="",
      drop_off="",
      ride_request_id="",
      payment_method="",
      rider_name="",
      rider_phone="";
  LatLng? pickUp=LatLng(0, 0), dropOff=LatLng(0, 0);
  RideDetails(
      {this.pickup_address,
      this.drop_off,
      this.pickUp,
      this.dropOff,
      this.ride_request_id,
      this.payment_method,
      this.rider_name,
      this.rider_phone});
}
