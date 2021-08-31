import 'package:cruiser_driver/configs/notifications/local_notification_service.dart';
import 'package:cruiser_driver/configs/notifications/notificationSound.dart';
import 'package:cruiser_driver/configs/rideDetails/rideRequestDetails.dart';
import 'package:cruiser_driver/configs/rideDetails/rideRequestId.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class PushNotificationService {
  static Future<void> setupInteractedMessage(BuildContext context) async {
    ///foreground app state notification handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      LocalNotificationService.display(message);
      await NotificationSound.notificationSound();
      await RideRequestDetails.retrieveRideDetails(
          RideRequestId.getRideRequestId(message), context);
    });

    ///terminated app state notification handler
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    _handleMessage(initialMessage, context);

    ///background app state notification handler
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) => _handleMessage(message, context));
  }

  ///BACKGROUND and TERMINATED state notifications HANDLER function.
  static void _handleMessage(
      RemoteMessage? message, BuildContext context) async {
    if (message != null) {
      ///retrieving ride details here instead of bg message handler ensures that only when
      ///the driver taps on notification it retrieves the ride details
      await RideRequestDetails.retrieveRideDetails(
          RideRequestId.getRideRequestId(message), context);
      final routeFromMessage = message.data["route"];
      if (routeFromMessage != null)
        Navigator.of(context).pushNamed(routeFromMessage);
    }
  }

}
