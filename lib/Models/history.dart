import 'package:firebase_database/firebase_database.dart';

class History{
  String PaymentMethod;
  String createdAt;
  String status;
  String fare;
  String dropoff;
  String pickup;
  History({this.PaymentMethod,this.createdAt,this.status,this.fare,this.dropoff,this.pickup});
  History.fromSnapshot(DataSnapshot snapshot){
    PaymentMethod=snapshot.value["payment_method"];
    createdAt=snapshot.value["created_at"];
    //status=snapshot.value["Driver Details"]["status"];
    status=snapshot.value["status"];
    fare=snapshot.value["fares"];
    dropoff=snapshot.value["dropoff_address"];
    pickup=snapshot.value["pickup_address"];
  }
}
