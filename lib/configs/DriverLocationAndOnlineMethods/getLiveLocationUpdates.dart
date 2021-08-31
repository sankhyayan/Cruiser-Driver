import 'dart:async';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';



class LiveLocationUpdates {
  static late StreamSubscription<Position> homeTabPageSubscription;
  static Future<void> liveLocationUpdates(BuildContext context) async {
    homeTabPageSubscription =
        Geolocator.getPositionStream().listen((Position position) async {
      await Geofire.setLocation(
          Provider.of<AppData>(context, listen: false).currentUserInfo.id!,
          position.latitude,
          position.longitude);

      ///creating latLng variable for live position
      LatLng latLng = LatLng(position.latitude, position.longitude);

      ///updating latLng in provider
      Provider.of<AppData>(context, listen: false).updateLatLng(latLng);
    });
  }

  ///driver offline setter
  static Future<void> liveLocationDispose(BuildContext context) async {
    Provider.of<AppData>(context, listen: false).clearAnimateMap();

    ///firebase reference for driver's state
    final DatabaseReference driverStateRef = driversRef
        .child(Provider.of<AppData>(context, listen: false).currentUserInfo.id!)
        .child("driverState");

    ///setting driver state OFFLINE in DB
    await driverStateRef.set("offline");
    await homeTabPageSubscription.cancel();
    await Geofire.stopListener();
    await Geofire.removeLocation(
        Provider.of<AppData>(context, listen: false).currentUserInfo.id!);
  }
}
