import 'dart:async';
import 'package:cruiser_driver/allScreens/newRideScreen/widgets/collectFareDialog.dart';
import 'package:cruiser_driver/configs/locationRequests/assistantMethods.dart';
import 'package:cruiser_driver/configs/locationRequests/userGeoLocator.dart';
import 'package:cruiser_driver/configs/newTripFunctions/mapKitAssistant/mapKitAssistant.dart';
import 'package:cruiser_driver/configs/newTripFunctions/updateRealtimeRideDetails/updateRideDetails.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:cruiser_driver/models/directionDetails.dart';
import 'package:cruiser_driver/models/rideDetails.dart';
import 'package:cruiser_driver/uiMessageWidgets/progressDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LiveLocationUpdateForTrip {
  Geolocator geoLocator = Geolocator();
  LocationOptions locationOptions =
      LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  static BitmapDescriptor animatingMarkerIcon = BitmapDescriptor.defaultMarker;

  ///car icon marker creator
  static void createLiveTripIconMarker(BuildContext context) {
    if (animatingMarkerIcon == BitmapDescriptor.defaultMarker) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "assets/images/car-android.png")
          .then((value) => animatingMarkerIcon = value);
    }
  }

  ///live ride location updates
  static late StreamSubscription<Position> rideStreamSubscription;
  static Future<void> liveRideLocationUpdates(BuildContext context) async {
    ///ride details
    RideDetails _rideDetails =
        Provider.of<AppData>(context, listen: false).newRideRequestDetails;

    ///defining a previous latLng to calculate degree to next LatLng
    LatLng oldPos = LatLng(0, 0);
    int countSeconds = 0;
    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) async {
      ///creating latLng variable for live position
      LatLng latLng = LatLng(position.latitude, position.longitude);

      ///accessing rotation of the icon based on old and current position
      num rotation = MapKitAssistant.getMarkerRotation(oldPos.latitude,
          oldPos.longitude, position.latitude, position.longitude);

      ///creating animating marker
      Marker animatingMarker = Marker(
        markerId: MarkerId("animating"),
        position: latLng,
        rotation: rotation.toDouble(),
        icon: animatingMarkerIcon,
        infoWindow: InfoWindow(title: "Current Location"),
      );

      ///updating latLng in provider
      Provider.of<AppData>(context, listen: false).updateLatLng(latLng);

      ///accessing rideMapMarkers and doing necessary functions
      Set<Marker> rideMapMarkers =
          Provider.of<AppData>(context, listen: false).mapMarkers;
      rideMapMarkers
          .removeWhere((marker) => marker.markerId.value == "animating");
      rideMapMarkers.add(animatingMarker);

      ///updating markers set in provider
      Provider.of<AppData>(context, listen: false)
          .updateMarkerSet(rideMapMarkers);

      ///updating location of driver in rider's end at realtime
      Map locMap = {
        "latitude": latLng.latitude.toString(),
        "longitude": latLng.longitude.toString(),
      };

      ///setting ride's driver LOCATION
      await newRideRequestRef
          .child(_rideDetails.ride_request_id!)
          .child("driver_location")
          .set(locMap);

      oldPos = latLng;
      countSeconds++;
      if (countSeconds == 20) {
        await UpdateRideDetails.updateRideDetails(
            latLng.latitude, latLng.longitude, context);
        print('Live Trip Update');
        countSeconds = 0;
      }
    });
  }

  ///ending trip
  static Future<void> endTrip(BuildContext context, double defaultSize) async {
    ///ride stream listener closed
    await rideStreamSubscription.cancel();

    ///ride details
    RideDetails _rideDetails =
        Provider.of<AppData>(context, listen: false).newRideRequestDetails;

    ///wait dialog
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ProgressDialog(
            defaultSize: defaultSize, message: "Please Wait..."));

    ///current driver position
    Position currentPosition = await UserGeoLocation.locatePosition();
    LatLng currentLatLng =
        LatLng(currentPosition.latitude, currentPosition.longitude);

    ///obtaining direction details to calculate fare amount
    DirectionDetails? directionDetails =
        await AssistantMethods.obtainPlaceDirectionsDetails(
            _rideDetails.pickUp!, currentLatLng);

    ///calculating fare
    int fareAmount = AssistantMethods.calculateFares(directionDetails!);

    ///setting trip ended
    await newRideRequestRef
        .child(_rideDetails.ride_request_id!)
        .child("status")
        .set("trip_ended");

    ///setting trip fare amount
    await newRideRequestRef
        .child(_rideDetails.ride_request_id!)
        .child("fare")
        .set(fareAmount.toString());
    Navigator.pop(context);

    ///payment dialog
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) => CollectFareDialog(
            defaultSize: defaultSize,
            paymentMethod: _rideDetails.payment_method!,
            fareAmount: fareAmount));
  }
}
