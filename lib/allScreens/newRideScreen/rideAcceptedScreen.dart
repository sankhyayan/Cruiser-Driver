import 'dart:async';

import 'package:cruiser_driver/allScreens/newRideScreen/widgets/riderDetailsContainer.dart';
import 'package:cruiser_driver/configs/locationRequests/placeDirection.dart';
import 'package:cruiser_driver/configs/locationRequests/userGeoLocator.dart';
import 'package:cruiser_driver/configs/newTripFunctions/setRideRequestDetailsWithDriverDetails/setRideRequestDetailsWithDesignatedDriverDetails.dart';
import 'package:cruiser_driver/configs/newTripFunctions/tripLiveLocationUpdates/liveLocationUpdateForTrip.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/configs/sizeConfig.dart';
import 'package:cruiser_driver/models/rideDetails.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class NewRideAcceptedScreen extends StatefulWidget {
  ///initial camera
  static final CameraPosition _initialCameraPos = CameraPosition(
    target: LatLng(22.570824771878623, 88.37058693225569),
    zoom: 14.4746,
  );
  static const String idScreen = "rideAcceptedScreen";
  @override
  _NewRideAcceptedScreenState createState() => _NewRideAcceptedScreenState();
}

class _NewRideAcceptedScreenState extends State<NewRideAcceptedScreen> {
  ///ride details updater with driver's details
  @override
  void didChangeDependencies() async {
    await SetRideRequestDetailsWithDesignatedDriverDetails.set(context);
    super.didChangeDependencies();
  }

  ///future handler completer
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  ///map controller
  late GoogleMapController newRideGoogleMapController;
  @override
  Widget build(BuildContext context) {
    ///creating live location marker
    LiveLocationUpdateForTrip.createLiveTripIconMarker(context);

    ///new ride details
    final RideDetails rideDetails =
        Provider.of<AppData>(context, listen: false).newRideRequestDetails;
    SizeConfig().init(context);
    final double defaultSize = SizeConfig.defaultSize;

    ///animate map to polyline constrains[LatLng Bounds]todo:add start navigation button
    if (Provider.of<AppData>(context).animateNewRideMap) {
      newRideGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(
          Provider.of<AppData>(context).latLngBounds, 90));

      ///stopping animate map to LatLng bounds
      Provider.of<AppData>(context, listen: false).clearNewRideAnimateMap();

      ///making driver online
      Provider.of<AppData>(context, listen: false).updateDriverOnline();
    }

    ///animating map with live location
    if (Provider.of<AppData>(context).isDriverOnline) {
      CameraPosition cameraPosition = CameraPosition(
          target: Provider.of<AppData>(context).latLng, zoom: 17);
      newRideGoogleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
    return Scaffold(
      body: Stack(
        children: [
          ///google map container
          GoogleMap(
            initialCameraPosition: NewRideAcceptedScreen._initialCameraPos,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: Provider.of<AppData>(context).mapMarkers,
            circles: Provider.of<AppData>(context).mapCircles,
            polylines: Provider.of<AppData>(context).polylineSet,
            onMapCreated: (GoogleMapController controller) async {
              _controllerGoogleMap.complete(controller);
              newRideGoogleMapController = controller;

              ///updating cam to current driver position
              newRideGoogleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                      await UserGeoLocation.getCamPosition()));

              ///current driver position
              Position currentPosition = await UserGeoLocation.locatePosition();
              LatLng currentLatLng =
                  LatLng(currentPosition.latitude, currentPosition.longitude);

              ///rider's pickup LatLng
              LatLng ridePickUpLatLng = rideDetails.pickUp!;

              ///getting rider pickup point in map after map is created
              ///marking map with polyline from DRIVER'S location to CUSTOMER'S[rider's] pickup location
              await PlaceDirection.getPlaceDirection(
                  context, defaultSize, currentLatLng, ridePickUpLatLng);

              await LiveLocationUpdateForTrip.liveRideLocationUpdates(context);

              ///updating newRideMapAnimateController check
              Provider.of<AppData>(context, listen: false)
                  .animateNewRideGoogleCamera();
            },
          ),

          ///RIDER's details container
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: RiderDetailsContainer(
                defaultSize: defaultSize,
              )),
        ],
      ),
    );
  }
}
