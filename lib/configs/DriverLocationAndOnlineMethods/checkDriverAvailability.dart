
import 'package:cruiser_driver/allScreens/newRideScreen/rideAcceptedScreen.dart';
import 'package:cruiser_driver/configs/DriverLocationAndOnlineMethods/getLiveLocationUpdates.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:cruiser_driver/uiMessageWidgets/errorSnackBars.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckDriverAvailability {
  static Future<void> checkAvailability(
      BuildContext context, double defaultSize) async {
    String driverState = "";

    ///firebase reference for driver's state
    final DatabaseReference driverStateRef = driversRef
        .child(
            Provider.of<AppData>(context, listen: false).currentDriverInfo.id!)
        .child("driverState");
    await driverStateRef.once().then((DataSnapshot dataSnapshot) async {
      if (await dataSnapshot.value != null) {
        driverState = dataSnapshot.value.toString();
      }

      ///if no such id exists[error handler]
      else {
        Navigator.pop(context);
        ErrorSnackBars.showFloatingSnackBar(
            context: context,
            defaultSize: defaultSize,
            errorText: "Ride doest not exist");
      }

      ///ride accepted by driver
      if (driverState ==
          Provider.of<AppData>(context, listen: false)
              .newRideRequestDetails
              .ride_request_id) {
        await LiveLocationUpdates.liveLocationDispose(context);
        ///making driver status accepted
        await driverStateRef
            .set("accepted"); //setting offline/online status to accepted.
        Provider.of<AppData>(context,listen: false).clearRideDuration();
        Navigator.popAndPushNamed(context, NewRideAcceptedScreen.idScreen);
      }

      ///ride cancelled by user
      else if (driverState == "cancelled") {
        Navigator.pop(context);
        ErrorSnackBars.showFloatingSnackBar(
            context: context,
            defaultSize: defaultSize,
            errorText: "Ride has been cancelled");
      }

      ///other drivers have already accepted this ride
      else if (driverState == "timeout") {
        Navigator.pop(context);
        ErrorSnackBars.showFloatingSnackBar(
            context: context,
            defaultSize: defaultSize,
            errorText: "Ride has timed out");
      }

      ///if no such id exists[error handler]
      else {
        Navigator.pop(context);
        ErrorSnackBars.showFloatingSnackBar(
            context: context,
            defaultSize: defaultSize,
            errorText: "Ride doest not exist");
      }
    });
  }
}
