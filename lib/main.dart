import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cruiser_driver/allScreens/carInfoScreen/carInfoScreen.dart';
import 'package:cruiser_driver/configs/notifications/local_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:cruiser_driver/allScreens/loginScreen/loginScreen.dart';
import 'package:cruiser_driver/allScreens/mainScreen/mainScreen.dart';
import 'package:cruiser_driver/allScreens/registrationScreen/registrationScreen.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';

import 'configs/notifications/notificationSound.dart';

///initializing assets audio player
final assetsAudioPlayer = AssetsAudioPlayer();

///background [OPENED and TERMINATED] app state notification data handler
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationSound.notificationSound();//todo:1)when app in bg no alert ring happens
                                              //todo:2)when app terminated alert ring happens BUT on cancel ride request ring doesn't stop
}

///creating global state isolate notification channel[top-level]
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "high_importance_channel", //channel ID
  "High Importance Notifications", //channel NAME
  "This channel is used fore important notifications", //channel DESCRIPTION
  importance: Importance.high,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  ///clearing default notification channel and setting my custom notification channel
  await LocalNotificationService.notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(UberClone());
}

///driver's db reference
final DatabaseReference driversRef = FirebaseDatabase(
        databaseURL:
            "https://uber-clone-64d20-default-rtdb.asia-southeast1.firebasedatabase.app")
    .reference()
    .child("Drivers");

///new ride request's db reference
final DatabaseReference newRideRequestRef = FirebaseDatabase(
        databaseURL:
            "https://uber-clone-64d20-default-rtdb.asia-southeast1.firebasedatabase.app")
    .reference()
    .child("Ride Requests").reference();


class UberClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Cruiser Driver',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.idScreen
            : MainScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          CarInfoScreen.idScreen: (context) => CarInfoScreen(),
        },
      ),
    );
  }
}
