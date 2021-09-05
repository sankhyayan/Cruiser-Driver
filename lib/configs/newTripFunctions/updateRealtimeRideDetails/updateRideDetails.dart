import 'package:cruiser_driver/configs/locationRequests/assistantMethods.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/models/directionDetails.dart';
import 'package:cruiser_driver/models/rideDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

///THIS ENTIRE FUNCTION WILL UPDATE EVERY SECOND IN REALTIME HENCE EVERYTHING WITHIN IT eg.Ride Duration SHALL UPDATE IN REALTIME
class UpdateRideDetails {
  ///accepted means driver has accepted the ride request and is driving towards pickup[**not yet picked up].
  static String durationOfRide = "";
  static late LatLng destinationLatLng;
  static Future<void> updateRideDetails(
      double lat, double lng, BuildContext context) async {
    String tripStatus = Provider.of<AppData>(context,listen: false).tripStatus;
    RideDetails _rideDetails =
        Provider.of<AppData>(context, listen: false).newRideRequestDetails;
    LatLng posLatLng = LatLng(lat, lng);
    if (tripStatus == "ARRIVED") {
      destinationLatLng = _rideDetails.pickUp!;
    }

    ///if anything other than accepted it means ride is in progress
    else {
      destinationLatLng = _rideDetails.dropOff!;
    }

    ///Be mindful of exhausting daily free quota
    DirectionDetails? directionDetails =
        await AssistantMethods.obtainPlaceDirectionsDetails(
            posLatLng, destinationLatLng);
    if (directionDetails != null) {
      durationOfRide = directionDetails.durationText!;
      Provider.of<AppData>(context, listen: false)
          .updateRideDuration(durationOfRide);
    }
  }
}
