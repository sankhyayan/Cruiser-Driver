import 'package:cruiser_driver/allScreens/newRideScreen/widgets/notificationDetailsDialog.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:cruiser_driver/models/rideDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RideRequestDetails {
  ///getting rider's ride details with ride ID
  static Future<void> retrieveRideDetails(
      String rideRequestId, BuildContext context) async {
    await newRideRequestRef
        .child(rideRequestId)
        .once()
        .then((DataSnapshot dataSnapshot) async {
      if (await dataSnapshot.value != null) {
        ///rider pickup Location
        double pickUpLocationLat =
            double.parse(dataSnapshot.value['pickUp']['latitude'].toString());
        double pickUpLocationLng =
            double.parse(dataSnapshot.value['pickUp']['longitude'].toString());
        String pickUpAddress = dataSnapshot.value['pickup_address'];

        ///rider dropOff Location
        double dropOffLocationLat =
            double.parse(dataSnapshot.value['dropOff']['latitude'].toString());
        double dropOffLocationLng =
            double.parse(dataSnapshot.value['dropOff']['longitude'].toString());
        String dropOffAddress = dataSnapshot.value['drop_off'];

        ///rider payment method
        String paymentMethod = dataSnapshot.value['payment_method'];

        ///rider name and phone no.
        String riderName = dataSnapshot.value["rider_name"];
        String riderPhone = dataSnapshot.value["rider_phone"];

        ///Mapping values to ride details map
        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickUpAddress;
        rideDetails.drop_off = dropOffAddress;
        rideDetails.pickUp = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropOff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;
        rideDetails.rider_name = riderName;
        rideDetails.rider_phone = riderPhone;

        ///updating ride details in provider
        Provider.of<AppData>(context, listen: false)
            .updateRideDetails(rideDetails);

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => NotificationDialog());
      } else {
        print("No ride request details available");
      }
    });
  }
}
