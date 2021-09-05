import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FcmTokenGetter {
  ///token getter
  static Future<void> getToken(BuildContext context) async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("This is the token:: $token");
    //todo:provider not providing current user here
    await driversRef
        .child(Provider.of<AppData>(context, listen: false).currentDriverInfo.id!)
        .child("token")
        .set(token);

    ///subscription topic names are CASE sensitive.
    ///Once subscribed to a topic a user CANNOT un-subscribe from it until he/she uninstalls the app or the developer un-subscribes in some way.
    ///topic subscription must always be initialized at start
    await FirebaseMessaging.instance.subscribeToTopic("allDrivers");
    await FirebaseMessaging.instance.subscribeToTopic("allUsers");
  }
}
