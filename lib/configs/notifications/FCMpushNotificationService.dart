import 'package:cruiser_driver/configs/notifications/local_notification_service.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/configs/rideDetails/rideRequestDetails.dart';
import 'package:cruiser_driver/configs/rideDetails/rideRequestId.dart';
import 'package:cruiser_driver/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PushNotificationService {
  static Future<void> setupInteractedMessage(BuildContext context) async {
    ///foreground app state notification handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.display(message);
      RideRequestDetails.retrieveRideDetails(RideRequestId.getRideRequestId(message));
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
  static void _handleMessage(RemoteMessage? message, BuildContext context) {
    if (message != null) {
      final routeFromMessage = message.data["route"];
      if (routeFromMessage != null)
        Navigator.of(context).pushNamed(routeFromMessage);
    }
  }

  static Future<void> getToken(BuildContext context) async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("This is the token:: $token");
    driversRef
        .child(Provider.of<AppData>(context, listen: false).currentUserInfo.id!)
        .child("token")
        .set(token);

    ///subscription topic names are CASE sensitive.
    ///Once subscribed to a topic a user CANNOT un-subscribe from it until he/she uninstalls the app or the developer un-subscribes in some way.
    ///topic subscription must always be initialized at start
    await FirebaseMessaging.instance.subscribeToTopic("allDrivers");
    await FirebaseMessaging.instance.subscribeToTopic("allUsers");
  }

}
