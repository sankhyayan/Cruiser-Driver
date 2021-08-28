import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/database/RideRequestMethods/saveRideRequests.dart';

class CancelRideRequest {
  static Future<void> cancelRideRequest(BuildContext context) async {
    await SaveRideRequest.rideRequestRef
        .child(Provider.of<AppData>(context, listen: false).currentUserInfo.id!)
        .remove();
  }
}
