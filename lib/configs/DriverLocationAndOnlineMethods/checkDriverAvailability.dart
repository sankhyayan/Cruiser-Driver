import 'package:cruiser_driver/SnackBars/errorSnackBars.dart';
import 'package:cruiser_driver/allScreens/newRideScreen/rideAcceptedScreen.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckDriverAvailability {
  static Future<void> checkAvailability(
      BuildContext context, double defaultSize) async {
    String newRideId = "";

    ///firebase reference for driver's state
    final DatabaseReference driverStateRef = driversRef
        .child(Provider.of<AppData>(context, listen: false).currentUserInfo.id!)
        .child("driverState");
    await driverStateRef.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        newRideId = dataSnapshot.value.toString();
      }

      ///if no such id exists[error handler]
      else {
        ErrorSnackBars.showFloatingSnackBar(
            context: context,
            defaultSize: defaultSize,
            errorText: "Ride doest not exist");
      }

      ///ride accepted by driver
      if (newRideId ==
          Provider.of<AppData>(context, listen: false)
              .newRideRequestDetails
              .ride_request_id) {
        driverStateRef
            .set("accepted"); //setting offline/online status to accepted.
        Provider.of<AppData>(context, listen: false).clearNewRideAnimateMap();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewRideAcceptedScreen(),
          ),
        );
      }

      ///ride cancelled by user
      else if (newRideId == "cancelled") {
        ErrorSnackBars.showFloatingSnackBar(
            context: context,
            defaultSize: defaultSize,
            errorText: "Ride has been cancelled");
      }

      ///other drivers have already accepted this ride
      else if (newRideId == "timeout") {
        ErrorSnackBars.showFloatingSnackBar(
            context: context,
            defaultSize: defaultSize,
            errorText: "Ride has timed out");
      }

      ///if no such id exists[error handler]
      else {
        ErrorSnackBars.showFloatingSnackBar(
            context: context,
            defaultSize: defaultSize,
            errorText: "Ride doest not exist");
      }
    });
  }
}
