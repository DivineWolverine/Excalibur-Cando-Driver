import 'package:firebase_database/firebase_database.dart';

class Drivers{
  String newRide;
  String name;
  String phone;
  String email;
  String id;
  String car_color;
  String car_model;
  String car_number;
  String type;
  Drivers({this.newRide,this.name,this.phone,this.email,this.id,this.car_color,this.car_model,this.car_number,this.type});
  Drivers.fromSnapshot(DataSnapshot datasnapshot){
    id=datasnapshot.key;
    phone=datasnapshot.value["phone"];
    newRide=datasnapshot.value["newRide"];
    email=datasnapshot.value["email"];
    name=datasnapshot.value["name"];
    car_color=datasnapshot.value["car_details"]["car_color"];
    car_model=datasnapshot.value["car_details"]["car_model"];
    car_number=datasnapshot.value["car_details"]["car_number"];
    type=datasnapshot.value["car_details"]["type"];
  }
}