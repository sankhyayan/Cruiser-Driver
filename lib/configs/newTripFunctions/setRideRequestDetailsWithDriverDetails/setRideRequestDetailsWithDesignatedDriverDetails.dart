import 'package:cruiser_driver/configs/locationRequests/userGeoLocator.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:cruiser_driver/models/driverDataFromSnapshot.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

///class for setting driver's details in ride request details
class SetRideRequestDetailsWithDesignatedDriverDetails{
  static Future<void> set(BuildContext context) async {
    ///getting new ride request ID
    String rideRequestId = Provider.of<AppData>(context, listen: false)
        .newRideRequestDetails
        .ride_request_id!;

    ///getting current logged in driver info
    DriverDataFromSnapshot currentDriverInfo =
        Provider.of<AppData>(context, listen: false).currentDriverInfo;

    ///setting ride status
    await newRideRequestRef
        .child(rideRequestId)
        .child("status")
        .set("accepted");

    ///setting ride's driver name
    await newRideRequestRef
        .child(rideRequestId)
        .child("driver_name")
        .set(currentDriverInfo.name);

    ///setting ride's driver phone
    await newRideRequestRef
        .child(rideRequestId)
        .child("driver_phone")
        .set(currentDriverInfo.phone);

    ///setting ride's driver ID
    await newRideRequestRef
        .child(rideRequestId)
        .child("driver_id")
        .set(currentDriverInfo.id);

    ///setting ride's driver CAR DETAILS
    await newRideRequestRef.child(rideRequestId).child("car_details").set(
        "${currentDriverInfo.car_color}-${currentDriverInfo.car_model}-${currentDriverInfo.car_number}");

    ///current driver position
    Position currentPosition = await UserGeoLocation.locatePosition();
    Map locMap = {
      "latitude": currentPosition.latitude.toString(),
      "longitude": currentPosition.longitude.toString(),
    };

    ///setting ride's driver LOCATION
    await newRideRequestRef
        .child(rideRequestId)
        .child("driver_location")
        .set(locMap);
  }
}
