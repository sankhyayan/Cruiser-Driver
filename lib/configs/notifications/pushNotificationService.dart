import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PushNotificationService {
  static Future<void> setupInteractedMessage(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Title: ${message.notification!.title}");//displaying foreground notification data
      print("Body: ${message.notification!.body}");
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    _handleMessage(initialMessage, context);

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
