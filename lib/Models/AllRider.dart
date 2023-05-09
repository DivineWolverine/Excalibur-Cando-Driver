
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class AllRider{
  String pickup_address;
  String dropoff_address;
  LatLng pickup;
  LatLng dropoff;
  String ride_request_id;
  String payment_method;
  String rider_name;
  String rider_phone;
  String driver_id;
  String driver_name;
  String driver_phone;
  String driver_email;
  String drivers_id;
  String car_color;
  String car_model;
  String car_number;
  String id;
  String type;
  AllRider({this.pickup_address,this.dropoff_address,this.pickup,this.dropoff,this.ride_request_id,this.payment_method,this.rider_name,this.rider_phone,this.driver_id,this.driver_name,this.driver_phone,this.driver_email,this.drivers_id,this.car_color,this.car_model,this.car_number,this.id,this.type});
AllRider.fromSnapshot(DataSnapshot snapshot){
  id=snapshot.key;
}
}