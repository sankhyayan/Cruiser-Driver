import 'package:cruiser_driver/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/models/driverDataFromSnapshot.dart';

class CurrentUser {
  static Future<void> getCurrentUserInfo(BuildContext context) async {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    await driversRef.child(firebaseUser.uid).once().then((DataSnapshot _dataSnapshot) async {
      if (await _dataSnapshot.value != null) {
        DriverDataFromSnapshot userCurrentInfo =
            DriverDataFromSnapshot.fromSnapshot(_dataSnapshot);
        Provider.of<AppData>(context, listen: false)
            .getCurrentUserInfo(userCurrentInfo);
      }
    });
  }
}
