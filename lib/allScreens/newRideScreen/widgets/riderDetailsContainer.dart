import 'package:cruiser_driver/configs/locationRequests/placeDirection.dart';
import 'package:cruiser_driver/configs/newTripFunctions/tripLiveLocationUpdates/liveLocationUpdateForTrip.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/main.dart';
import 'package:cruiser_driver/models/rideDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RiderDetailsContainer extends StatelessWidget {
  final double defaultSize;
  RiderDetailsContainer({required this.defaultSize});

  @override
  Widget build(BuildContext context) {
    RideDetails rideDetails =
        Provider.of<AppData>(context, listen: false).newRideRequestDetails;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultSize * 1.6),
          topRight: Radius.circular(defaultSize * 1.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: defaultSize * 1.6,
            spreadRadius: .5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      height: defaultSize * 27,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultSize * 2.4, vertical: defaultSize * 1.8),
        child: Column(
          children: [
            ///time of travel
            Text(
              Provider.of<AppData>(context).rideDuration,
              style: TextStyle(
                  fontSize: defaultSize * 1.4,
                  fontFamily: "Brand Bold",
                  color: Colors.black),
            ),
            SizedBox(
              height: defaultSize * .6,
            ),

            ///rider name and call
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  rideDetails.rider_name!,
                  style: TextStyle(
                      fontSize: defaultSize * 2.4,
                      fontFamily: "Brand Bold",
                      color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.only(right: defaultSize),
                  child: Icon(Icons.call),
                ),
              ],
            ),
            SizedBox(
              height: defaultSize * 2.2,
            ),

            ///pickup destination
            Row(
              children: [
                Image.asset(
                  "assets/images/pickicon.png",
                  height: defaultSize * 1.6,
                  width: defaultSize * 1.6,
                ),
                SizedBox(
                  width: defaultSize * 1.8,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      rideDetails.pickup_address!,
                      style: TextStyle(fontSize: defaultSize * 1.8),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: defaultSize * 1.5,
            ),

            ///drop off destination
            Row(
              children: [
                Image.asset(
                  "assets/images/desticon.png",
                  height: defaultSize * 1.6,
                  width: defaultSize * 1.6,
                ),
                SizedBox(
                  width: defaultSize * 1.8,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      rideDetails.drop_off!,
                      style: TextStyle(fontSize: defaultSize * 1.8),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: defaultSize * 2.7,
            ),

            ///driver arrived or not button
            GestureDetector(
              onTap: () async {
                switch (Provider.of<AppData>(context,listen: false).tripStatus) {
                  ///arrived at pickup location
                  case "ARRIVED":
                    ///changing to start trip option
                    Provider.of<AppData>(context, listen: false).startTrip();
                    await newRideRequestRef
                        .child(rideDetails.ride_request_id!)
                        .child("status")
                        .set("arrived");//todo trip status not setting
                    break;
                  ///trip started
                  case "START TRIP":
                    ///changing to end trip option
                    Provider.of<AppData>(context, listen: false).endTrip();
                    await newRideRequestRef
                        .child(rideDetails.ride_request_id!)
                        .child("status")
                        .set("trip_started");//todo trip status not setting
                    ///getting trip direction from pickup to drop off of rider
                    await PlaceDirection.getPlaceDirection(context, defaultSize,
                        rideDetails.pickUp!, rideDetails.dropOff!);
                    break;
                  ///trip ended
                  case "END TRIP":
                    ///resetting trip status
                    Provider.of<AppData>(context, listen: false).resetTrip();
                    ///ending trip
                    await LiveLocationUpdateForTrip.endTrip(
                        context, defaultSize);
                    break;
                }
              },
              child: Container(
                height: defaultSize * 6.8,
                decoration: BoxDecoration(
                  color: Provider.of<AppData>(context, listen: false).tripStatus == "ARRIVED" ? Colors.black : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: defaultSize * 4,
                      spreadRadius: defaultSize * .2,
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultSize * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Provider.of<AppData>(context, listen: false).tripStatus,
                        style: TextStyle(
                            color: Provider.of<AppData>(context, listen: false).tripStatus == "ARRIVED"
                                ? Colors.white
                                : Colors.black,
                            fontSize: defaultSize * 2),
                      ),
                      Icon(
                        Icons.arrow_right_alt_sharp,
                        color: Provider.of<AppData>(context, listen: false).tripStatus == "ARRIVED"
                            ? Colors.white
                            : Colors.black,
                        size: defaultSize * 4.5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
