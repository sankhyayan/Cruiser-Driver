import 'package:cruiser_driver/models/rideDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cruiser_driver/database/RideRequestMethods/cancelRideRequest.dart';
import 'package:cruiser_driver/models/address.dart';
import 'package:cruiser_driver/models/directionDetails.dart';
import 'package:cruiser_driver/models/driverDataFromSnapshot.dart';

class AppData extends ChangeNotifier {
  Address pickupLocation = Address(placeName: "Add Home");
  Address dropOffLocation = Address(placeName: "Add Drop");
  Set<Marker> mapMarkers = {};
  Set<Circle> mapCircles = {};
  Set<Polyline> polylineSet = {};
  String rideDuration = "";
  int tabIndex = 0;
  bool isDriverOnline = false;
  bool googleMapUpdated = false;
  RideDetails newRideRequestDetails = RideDetails();
  DriverDataFromSnapshot currentDriverInfo = DriverDataFromSnapshot();
  DirectionDetails directionDetails = DirectionDetails(
      durationValue: 0, distanceValue: 0, distanceText: "", durationText: "");
  bool animateNewRideMap = false;
  String response = "";
  bool rideRequest = false;
  String tripStatus = "ARRIVED";
  LatLngBounds latLngBounds =
      LatLngBounds(southwest: LatLng(0.0, 0.0), northeast: LatLng(0.0, 0.0));
  LatLng latLng = LatLng(0, 0);

  void updatePickupLocation(Address _pickupAddress) {
    pickupLocation = _pickupAddress;
    notifyListeners();
  }

  void updateRideDuration(String _rideDuration) {
    rideDuration = _rideDuration;
    notifyListeners();
  }

  void updateRideDetails(RideDetails _rideDetails) {
    newRideRequestDetails = _rideDetails;
    notifyListeners();
  }
  void resetTrip(){
    tripStatus="ARRIVED";
    notifyListeners();
  }
  void startTrip() {
    tripStatus = "START TRIP";
    notifyListeners();
  }

  void endTrip() {
    tripStatus = "END TRIP";
    notifyListeners();
  }

  void updateGoogleMapControllerInitialization() {
    googleMapUpdated = true;
    notifyListeners();
  }

  void updateMainPageTab(int _index) {
    tabIndex = _index;
    notifyListeners();
  }

  void updateDriverOnline() {
    isDriverOnline = true;
    notifyListeners();
  }

  void updateDropOffLocation(Address _dropOffAddress) {
    dropOffLocation = _dropOffAddress;
    notifyListeners();
  }

  void updatePolyLineSet(Set<Polyline> _polylineSet) {
    polylineSet = _polylineSet;
    notifyListeners();
  }

  void updateMarkerSet(Set<Marker> _mapMarkers) {
    mapMarkers = _mapMarkers;
    notifyListeners();
  }

  void updateCircleSet(Set<Circle> _mapCircles) {
    mapCircles = _mapCircles;
    notifyListeners();
  }

  void updateLatLngBounds(LatLngBounds _latLngBounds) {
    latLngBounds = _latLngBounds;
    notifyListeners();
  }

  void updateLatLng(LatLng _latLng) {
    latLng = _latLng;
    notifyListeners();
  }

  void updateResponse(String _response) {
    response = _response;
    notifyListeners();
  }

  void animateNewRideGoogleCamera() {
    animateNewRideMap = true;
    notifyListeners();
  }

  void updateDirectionDetails(DirectionDetails _directionDetails) {
    directionDetails = _directionDetails;
    notifyListeners();
  }

  void updateRideRequest() {
    rideRequest = true;
    notifyListeners();
  }

  void getCurrentUserInfo(DriverDataFromSnapshot _currentUSerInfo) {
    currentDriverInfo = _currentUSerInfo;
    notifyListeners();
  }

  void clearPolyLineSet() {
    polylineSet.clear();
    notifyListeners();
  }

  void clearMarkersSet() {
    mapMarkers.clear();
    notifyListeners();
  }

  void clearCirclesSet() {
    mapCircles.clear();
    notifyListeners();
  }

  void clearNewRideAnimateMap() {
    animateNewRideMap = false;
    notifyListeners();
  }

  void clearRideRequest(BuildContext context) async {
    await CancelRideRequest.cancelRideRequest(context);
    rideRequest = false;
    notifyListeners();
  }

  void clearGoogleMapControllerInitialization() {
    googleMapUpdated = false;
    notifyListeners();
  }

  void clearDriverOnline() {
    isDriverOnline = false;
    notifyListeners();
  }

  void clearRideDuration() {
    rideDuration = "";
    notifyListeners();
  }
}
