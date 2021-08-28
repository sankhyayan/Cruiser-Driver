import 'package:cruiser_driver/allScreens/mainScreen/tabPages/eariningsTabPage.dart';
import 'package:cruiser_driver/allScreens/mainScreen/tabPages/homeTabPage.dart';
import 'package:cruiser_driver/allScreens/mainScreen/tabPages/profileTabPage.dart';
import 'package:cruiser_driver/allScreens/mainScreen/tabPages/ratingTabPage.dart';
import 'package:cruiser_driver/allScreens/mainScreen/widgets/driverOnlineOffline.dart';
import 'package:cruiser_driver/configs/DriverLocationOnlineMethods/getLiveLocationUpdates.dart';
import 'package:cruiser_driver/configs/notifications/pushNotificationService.dart';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:cruiser_driver/configs/sizeConfig.dart';
import 'package:cruiser_driver/database/authMethods/CurrentUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  ///init state
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    CurrentUser.getCurrentUserInfo(context);
    PushNotificationService.setupInteractedMessage(context);
    PushNotificationService.getToken(context);
  }

  ///dispose method
  @override
  void dispose() {
    super.dispose();
    LiveLocationUpdates.liveLocationDispose(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      ///driver online offline
      appBar: AppBar(
        backgroundColor: Colors.black,
        leadingWidth: defaultSize * 15,

        ///driver online offline container
        leading: DriverOnlineOffline(
          defaultSize: defaultSize,
        ),
      ),

      ///setting up tab bar view screen
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),

      ///setting up bottom nav bar
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: "Earnings"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Rating"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],

        ///bottom nav bar item properties
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: Provider.of<AppData>(context).tabIndex,
        showUnselectedLabels: true,

        ///provider setUp to avoid setState :P
        onTap: (index) {
          if (index != 0) {
            ///updating googleMapControllerProvider
            Provider.of<AppData>(context, listen: false)
                .clearGoogleMapControllerInitialization();
          }
          Provider.of<AppData>(context, listen: false).updateMainPageTab(index);
          tabController.index = index;
        },
      ),
    );
  }
}
