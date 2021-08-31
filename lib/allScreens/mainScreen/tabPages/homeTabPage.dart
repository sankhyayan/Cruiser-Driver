import 'dart:async';

import 'package:cruiser_driver/configs/locationRequests/userGeoLocator.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeTabPage extends StatefulWidget {
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  ///future handler completer
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  ///initial camera
  final CameraPosition _initialCameraPos = CameraPosition(
    target: LatLng(22.570824771878623, 88.37058693225569),
    zoom: 14.4746,
  );

  ///map controller
  late GoogleMapController newGoogleMapController;

  @override
  Widget build(BuildContext context) {
    ///animate map check?
    if (Provider.of<AppData>(context).animateMap &&
        Provider.of<AppData>(context).googleMapUpdated) {
      newGoogleMapController.animateCamera(
          CameraUpdate.newLatLng(Provider.of<AppData>(context).latLng));
    }
    return Scaffold(
      body: Stack(
        children: [
          ///google map container
          GoogleMap(
            initialCameraPosition: _initialCameraPos,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) async {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              ///camera update position to current position on start
              await newGoogleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                      await UserGeoLocation.getCamPosition()));

              ///updating googleMapControllerProvider
              Provider.of<AppData>(context, listen: false)
                  .updateGoogleMapControllerInitialization();
            },
          ),
        ],
      ),
    );
  }
}
