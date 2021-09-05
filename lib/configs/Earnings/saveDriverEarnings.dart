import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

///saving total earnings in database
class SaveDriverEarnings {
  static Future<void> save(int latestFareAmount, BuildContext context) async {
    await driversRef
        .child(
            Provider.of<AppData>(context, listen: false).currentDriverInfo.id!)
        .child("earnings")
        .once()
        .then((DataSnapshot dataSnapshot) async {
      ///checking if old earnings exist
      if (await dataSnapshot.value != null) {
        ///storing old earnings
        int oldEarnings = int.parse(dataSnapshot.value.toString());
        int totalEarnings =
            latestFareAmount + oldEarnings; //calculating total earnings
        ///setting total earnings
        await driversRef
            .child(Provider.of<AppData>(context, listen: false)
                .currentDriverInfo
                .id!)
            .child("earnings")
            .set(totalEarnings.toString());
      } else if (dataSnapshot.value == null) {
        ///setting total earnings for new driver user
        await driversRef
            .child(Provider.of<AppData>(context, listen: false)
                .currentDriverInfo
                .id!)
            .child("earnings")
            .set(latestFareAmount.toString());
      }
    });
  }
}
