import 'package:cruiser_driver/configs/locationRequests/userGeoLocator.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MakeDriverOnlineNow {
  static Future<void> makeDriverOnlineNow(BuildContext context) async {
    ///firebase reference todo:not necessary here maybe?see later
    final DatabaseReference rideRequestRef = FirebaseDatabase(
            databaseURL:
                "https://uber-clone-64d20-default-rtdb.asia-southeast1.firebasedatabase.app")
        .reference()
        .child("Drivers")
        .child(Provider.of<AppData>(context, listen: false).currentUserInfo.id!)
        .child("newRideRequest");

    ///getting current position
    Position currentPosition = await UserGeoLocation.locatePosition();

    ///initializing live data location and setting location in rdb
    await Geofire.initialize("availableDrivers");
    await Geofire.setLocation(
      Provider.of<AppData>(context, listen: false).currentUserInfo.id!,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    ///creating latLng variable for live position
    LatLng latLng = LatLng(currentPosition.latitude, currentPosition.longitude);

    ///updating latLng in provider
    Provider.of<AppData>(context, listen: false).updateLatLng(latLng);

    ///updating animate checker in provider AFTER getting latLng
    Provider.of<AppData>(context, listen: false).animateGoogleCamera();
  }
}
