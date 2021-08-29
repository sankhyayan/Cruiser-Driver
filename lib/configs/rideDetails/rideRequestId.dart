import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class RideRequestId {
  ///accessing ride ID from FCM notification
  static String getRideRequestId(RemoteMessage message) {
    String rideRequestId = "";
    if (Platform.isAndroid) {
      rideRequestId = message.data['ride_request_id'];
    }
    return rideRequestId;
  }
}
