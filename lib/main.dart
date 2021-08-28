import 'package:cruiser_driver/allScreens/carInfoScreen/carInfoScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cruiser_driver/allScreens/loginScreen/loginScreen.dart';
import 'package:cruiser_driver/allScreens/mainScreen/mainScreen.dart';
import 'package:cruiser_driver/allScreens/registrationScreen/registrationScreen.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.data.toString());
  print(message.notification!.title);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(UberClone());
}

final DatabaseReference driversRef = FirebaseDatabase(
        databaseURL:
            "https://uber-clone-64d20-default-rtdb.asia-southeast1.firebasedatabase.app")
    .reference()
    .child("Drivers");

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
