import 'package:cruiser_driver/configs/DriverLocationAndOnlineMethods/checkDriverAvailability.dart';
import 'package:cruiser_driver/configs/sizeConfig.dart';
import 'package:cruiser_driver/main.dart';
import 'package:cruiser_driver/models/rideDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final RideDetails rideDetails;
  NotificationDialog({required this.rideDetails});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final double defaultSize = SizeConfig.defaultSize;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultSize * 2.5)),
      backgroundColor: Colors.transparent,
      elevation: 8.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(defaultSize * 2.5),
              topRight: Radius.circular(defaultSize * 2.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: defaultSize * 1.6,
            ),

            ///example widget for now todo: change later
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Rider's Image",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: defaultSize * 1.8,
            ),
            Text(
              "New Ride Request",
              style: TextStyle(
                  fontFamily: "Brand Bold", fontSize: defaultSize * 1.8),
            ),
            SizedBox(
              height: defaultSize * 3,
            ),
            ///pickup drop off locations
            Column(
              children: [
                ///pickup location
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultSize * 2,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/pickicon.png",
                        height: defaultSize * 1.6,
                        width: defaultSize * 1.6,
                      ),
                      SizedBox(
                        width: defaultSize * 2,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails.pickup_address!,
                            style: TextStyle(
                                fontSize: defaultSize * 1.8,
                                fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultSize * .3),
                  child: Image.asset(
                    "assets/images/arrow_down.png",
                    height: defaultSize * 6,
                  ),
                ),
                ///drop off location
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultSize * 2,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/desticon.png",
                        height: defaultSize * 1.6,
                        width: defaultSize * 1.6,
                      ),
                      SizedBox(
                        width: defaultSize * 2,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails.drop_off!,
                            style: TextStyle(
                                fontSize: defaultSize * 1.8,
                                fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: defaultSize * 1.5,
                ),
              ],
            ),
            SizedBox(height: defaultSize*2,),
            ///accept reject
            Column(
              children: [
                ///accept
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await assetsAudioPlayer.stop();
                    await CheckDriverAvailability.checkAvailability(
                        context, defaultSize);
                  },
                  child: Container(
                    height: defaultSize * 7,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: defaultSize * 4,
                          spreadRadius: defaultSize * .2,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultSize*2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ACCEPT",
                            style: TextStyle(
                                color: Colors.white, fontSize: defaultSize * 2),
                          ),
                          Icon(
                            Icons.arrow_right_alt_sharp,
                            color: Colors.white,
                            size: defaultSize * 4.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ///reject
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await assetsAudioPlayer.stop();
                  },
                  child: Container(
                    height: defaultSize *6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding:EdgeInsets.symmetric(horizontal: defaultSize*2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "REJECT",
                            style: TextStyle(
                                color: Colors.black, fontSize: defaultSize * 2),
                          ),
                          Icon(
                            Icons.cancel_sharp,
                            size: defaultSize * 3.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
