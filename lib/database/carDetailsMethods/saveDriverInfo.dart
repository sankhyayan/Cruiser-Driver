import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SaveDriverCarInfo {
  static Future<bool> saveDriverCarInfo(BuildContext context, String carColor,
      String carModel, String carNumber) async {
    ///getting new registered user Id
    String userId =
        Provider.of<AppData>(context, listen: false).currentDriverInfo.id!;

    ///mapping car info details
    Map carInfoMap = {
      "car_color": carColor,
      "car_number": carNumber,
      "car_model": carModel
    };
    try {
      await driversRef.child(userId).child("car_details").set(carInfoMap);
      return true;
    } on Exception catch (e) {
      print("Car Details Not Set::$e");
      return false;
    }
  }
}
