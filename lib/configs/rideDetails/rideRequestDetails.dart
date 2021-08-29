import 'package:cruiser_driver/main.dart';
import 'package:cruiser_driver/models/rideDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRequestDetails {
  ///getting ride details with ride ID
  static void retrieveRideDetails(String rideRequestId) {
    newRideRequestRef
        .child(rideRequestId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        ///pickup Location
        double pickUpLocationLat =
            double.parse(dataSnapshot.value['pickUp']['latitude'].toString());
        double pickUpLocationLng =
            double.parse(dataSnapshot.value['pickUp']['longitude'].toString());
        String pickUpAddress = dataSnapshot.value['pickup_address'];

        ///dropOff Location
        double dropOffLocationLat =
            double.parse(dataSnapshot.value['dropOff']['latitude'].toString());
        double dropOffLocationLng =
            double.parse(dataSnapshot.value['dropOff']['longitude'].toString());
        String dropOffAddress = dataSnapshot.value['drop_off'];

        ///payment method
        String paymentMethod = dataSnapshot.value['payment_method'];

        ///Mapping values to ride details map
        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickUpAddress;
        rideDetails.drop_off = dropOffAddress;
        rideDetails.pickUp = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropOff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;
      }
    });
  }
}
