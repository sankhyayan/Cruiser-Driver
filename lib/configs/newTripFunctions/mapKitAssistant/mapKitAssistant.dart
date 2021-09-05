import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitAssistant {
  ///gets the amount and no. of rotations required from point A to B.
  static num getMarkerRotation(
      double srcLat, double srcLng, double dropLat, double dropLng) {
    var rotation = SphericalUtil.computeHeading(
        LatLng(srcLat, srcLng), LatLng(dropLat, dropLng));
    return rotation;

    ///* num is an abstract class[here variable]which is either a float or int.Its erroneous to use num in computation of any types other than float,double and int *///
  }
}
