
import 'package:cruiser_driver/allScreens/mainScreen/mainScreen.dart';
import 'package:cruiser_driver/uiMessageWidgets/progressDialog.dart';
import 'package:cruiser_driver/configs/sizeConfig.dart';
import 'package:cruiser_driver/database/carDetailsMethods/saveDriverInfo.dart';
import 'package:cruiser_driver/uiMessageWidgets/errorSnackBars.dart';
import 'package:flutter/material.dart';

class CarInfoScreen extends StatelessWidget {
  static const String idScreen = "carInfo";
  final TextEditingController carModelEditingController =
      TextEditingController();
  final TextEditingController carNumberEditingController =
      TextEditingController();
  final TextEditingController carColorEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: defaultSize * 2.2,
              ),
              Image.asset(
                "assets/images/logoTaxi.JPG",
                width: defaultSize * 39,
                height: defaultSize * 25,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(defaultSize * 2.2,
                    defaultSize * 2.2, defaultSize * 2.2, defaultSize * 3.2),
                child: Column(
                  children: [
                    SizedBox(
                      height: defaultSize * 1.2,
                    ),
                    Text(
                      "Enter Car Details",
                      style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: defaultSize * 2.4),
                    ),

                    ///car model textField
                    SizedBox(
                      height: defaultSize * 2.6,
                    ),
                    TextField(
                      controller: carModelEditingController,
                      decoration: InputDecoration(
                        labelText: "Car Model",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: defaultSize * 2,
                            fontFamily: "Brand Bold"),
                      ),
                      style: TextStyle(
                          fontSize: defaultSize * 2, fontFamily: "Brand Bold"),
                    ),

                    ///car number textField
                    SizedBox(
                      height: defaultSize,
                    ),
                    TextField(
                      controller: carNumberEditingController,
                      decoration: InputDecoration(
                        labelText: "Car Number",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: defaultSize * 2,
                            fontFamily: "Brand Bold"),
                      ),
                      style: TextStyle(
                          fontSize: defaultSize * 2, fontFamily: "Brand Bold"),
                    ),

                    ///car color textField
                    SizedBox(
                      height: defaultSize,
                    ),
                    TextField(
                      controller: carColorEditingController,
                      decoration: InputDecoration(
                        labelText: "Car Color",
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: defaultSize * 2,
                            fontFamily: "Brand Bold"),
                      ),
                      style: TextStyle(
                          fontSize: defaultSize * 2, fontFamily: "Brand Bold"),
                    ),
                    SizedBox(
                      height: defaultSize * 6.5,
                    ),

                    ///car Info save button
                    RaisedButton(
                      padding: EdgeInsets.symmetric(
                          vertical: defaultSize * 1.4,
                          horizontal: defaultSize * 1.5),
                      elevation: defaultSize * 1.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(defaultSize * 2),
                          side: BorderSide.none),
                      color: Colors.black,
                      onPressed: () async {
                        ///checks if car model field is empty?
                        if (carModelEditingController.text.isEmpty) {
                          ErrorSnackBars.showFloatingSnackBar(
                              context: context,
                              defaultSize: defaultSize,
                              errorText: "Enter Car Model");
                        }

                        ///checks if car number field is empty?
                        else if (carNumberEditingController.text.isEmpty) {
                          ErrorSnackBars.showFloatingSnackBar(
                              context: context,
                              defaultSize: defaultSize,
                              errorText: "Enter Car Number");
                        }

                        ///checks if car color field is empty?
                        else if (carColorEditingController.text.isEmpty) {
                          ErrorSnackBars.showFloatingSnackBar(
                              context: context,
                              defaultSize: defaultSize,
                              errorText: "Enter Car Color");
                        } else {
                          ///progress dialog indicator
                          showDialog(
                            barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return ProgressDialog(
                                    defaultSize: defaultSize,
                                    message:
                                        "Saving Details, Please wait...");
                              });
                          bool saved =
                              await SaveDriverCarInfo.saveDriverCarInfo(
                            context,
                            carColorEditingController.text.trim(),
                            carModelEditingController.text.trim(),
                            carNumberEditingController.text.trim(),
                          );
                          ///if saved... else...
                          if (saved) {
                            ErrorSnackBars.showFloatingSnackBar(
                                context: context,
                                defaultSize: defaultSize,
                                errorText: "Details Saved");
                            ///popping progress dialog
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                                context, MainScreen.idScreen, (route) => false);

                          } else {
                            ErrorSnackBars.showFloatingSnackBar(
                                context: context,
                                defaultSize: defaultSize,
                                errorText: "Details could not be Saved");
                            Navigator.pop(context);

                            ///popping progress dialog
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          defaultSize * .5,
                          0.0,
                          defaultSize * .5,
                          0.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "NEXT",
                              style: TextStyle(
                                fontSize: defaultSize * 2,
                                fontFamily: "Brand Bold",
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.next_week_outlined,
                              color: Colors.white,
                              size: defaultSize * 2.8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
