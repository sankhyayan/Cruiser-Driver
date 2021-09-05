import 'package:cruiser_driver/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';

class CancelRideRequest {
  static Future<void> cancelRideRequest(BuildContext context) async {
    await newRideRequestRef
        .child(Provider.of<AppData>(context, listen: false).currentDriverInfo.id!)
        .remove();
  }
}
