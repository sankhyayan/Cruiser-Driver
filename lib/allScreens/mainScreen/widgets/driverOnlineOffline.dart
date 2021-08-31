import 'package:cruiser_driver/SnackBars/errorSnackBars.dart';
import 'package:cruiser_driver/configs/DriverLocationAndOnlineMethods/getLiveLocationUpdates.dart';
import 'package:cruiser_driver/configs/DriverLocationAndOnlineMethods/makeDriverOnlineNow.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverOnlineOffline extends StatelessWidget {
  final double defaultSize;
  const DriverOnlineOffline({required this.defaultSize});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.only(left: defaultSize),
      elevation: defaultSize * 1.5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(defaultSize * 3),
              bottomRight: Radius.circular(defaultSize * 3)),
          side: BorderSide.none),
      color: Provider.of<AppData>(context).isDriverOnline
          ? Colors.white
          : Colors.black,

      ///setting driver online/offline
      onPressed: () async {
        if (!Provider.of<AppData>(context, listen: false).isDriverOnline) {
          ///setting driver online
          Provider.of<AppData>(context, listen: false).updateDriverOnline();
          await MakeDriverOnlineNow.makeDriverOnlineNow(context);
          await LiveLocationUpdates.liveLocationUpdates(context);
          ErrorSnackBars.showFloatingSnackBar(
              context: context,
              defaultSize: defaultSize,
              errorText: "You are now Visible");
        } else {
          ///setting driver offline
          Provider.of<AppData>(context, listen: false).clearDriverOnline();
          LiveLocationUpdates.liveLocationDispose(context);
          ErrorSnackBars.showFloatingSnackBar(
              context: context,
              defaultSize: defaultSize,
              errorText: "You are not Visible");
        }
      },

      ///buttons offline online
      child: Row(
        children: [
          Text(
            Provider.of<AppData>(context).isDriverOnline ? "ONLINE" : "OFFLINE",
            style: TextStyle(
              fontSize: defaultSize * 2,
              fontFamily: "Brand Bold",
              color: Provider.of<AppData>(context).isDriverOnline
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          SizedBox(
            width: defaultSize,
          ),
          Icon(
            Provider.of<AppData>(context).isDriverOnline
                ? Icons.phone_android
                : Icons.phonelink_erase_rounded,
            color: Provider.of<AppData>(context).isDriverOnline
                ? Colors.black
                : Colors.white,
            size: defaultSize * 2.8,
          ),
        ],
      ),
    );
  }
}
