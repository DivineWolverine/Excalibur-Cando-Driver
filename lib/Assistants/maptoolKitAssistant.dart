import 'package:maps_toolkit/maps_toolkit.dart';

class maptoolKitAssistant{
  static double getMarkerRotation(slat,slon,dlat,dlon){
    var rot=SphericalUtil.computeHeading(LatLng(slat, slon), LatLng(dlat, dlon));
    return rot;
  }
}