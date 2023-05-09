
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class RiderDetails{
  // String id;
  String pickup_address;
  String dropoff_address;
  LatLng pickup;
  LatLng dropoff;
  String ride_request_id;
  String payment_method;
  String rider_name;
  String rider_phone;
  String driver_id;

  RiderDetails({this.pickup_address,this.dropoff_address,this.pickup,this.dropoff,this.ride_request_id,this.payment_method,this.rider_name,this.rider_phone,this.driver_id});
  // RiderDetails.fromSnapshot(DataSnapshot snapshot){
  //   id=snapshot.key;
  // }

}