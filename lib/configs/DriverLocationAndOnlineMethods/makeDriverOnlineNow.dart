import 'package:cruiser_driver/configs/locationRequests/userGeoLocator.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MakeDriverOnlineNow {
  static Future<void> makeDriverOnlineNow(BuildContext context) async {
    ///firebase reference for driver's state
    final DatabaseReference driverStateRef = driversRef
        .child(Provider.of<AppData>(context, listen: false).currentDriverInfo.id!)
        .child("driverState");

    ///getting current position
    Position currentPosition = await UserGeoLocation.locatePosition();

    ///initializing live data location and setting location in rdb
    await Geofire.initialize("availableDrivers");
    await Geofire.setLocation(
      Provider.of<AppData>(context, listen: false).currentDriverInfo.id!,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    ///setting driver state ONLINE in DB
    await driverStateRef.set("searching");

    ///creating latLng variable for live position
    LatLng latLng = LatLng(currentPosition.latitude, currentPosition.longitude);

    ///updating latLng in provider
    Provider.of<AppData>(context, listen: false).updateLatLng(latLng);

    ///making driver online
    Provider.of<AppData>(context, listen: false).updateDriverOnline();
  }
}
