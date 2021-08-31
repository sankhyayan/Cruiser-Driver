import 'package:flutter/material.dart';

class RiderDetailsContainer extends StatelessWidget {
  final double defaultSize;
  RiderDetailsContainer({required this.defaultSize});

  @override
  Widget build(BuildContext context) {
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
              "10 mins",
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
                  "Rider Name",
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
                      "Pickup Destination name",
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
                      "Drop Off Destination name",
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
              onTap: () async {},
              child: Container(
                height: defaultSize * 6.8,
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
                  padding: EdgeInsets.symmetric(horizontal: defaultSize * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ARRIVED",
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
          ],
        ),
      ),
    );
  }
}
