
import 'package:cando_driver_app/AllScreens/newRideScreen.dart';
import 'package:cando_driver_app/Models/riderDetails.dart';
import 'package:cando_driver_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


  class NotificationDialog extends StatefulWidget {
    final RiderDetails riderDetails;
    NotificationDialog({this.riderDetails});
  @override
  _NotificationDialogState createState() => _NotificationDialogState();
  }

  class _NotificationDialogState extends State<NotificationDialog> {
    @override
    Widget build(BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),backgroundColor: Colors.transparent,
        elevation: 1.0,
        child: Container(
          margin: EdgeInsets.all(5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30.0,),
              Image.asset("images/taxi.png",width: 120.0,),
              SizedBox(height: 18.0,),
              Text("New Ride Request",style: TextStyle(
                fontFamily: "Brand-Bold",fontSize: 18.0,
              ),),
              SizedBox(height: 30.0,),
              Padding(padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("images/pickicon.png",height: 16.0,width: 16.0,),
                        SizedBox(width: 20.0,),
                        Expanded(child:    Container(
                          child: Text(widget.riderDetails.pickup_address,style: TextStyle(
                            fontSize: 18.0,

                          ),),
                        ),),

                      ],
                    ),SizedBox(height: 30.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("images/desticon.png",height: 16.0,width: 16.0,),
                        SizedBox(width: 20.0,),
                        Expanded(child: Container(
                          child: Text(widget.riderDetails.dropoff_address,style: TextStyle(
                            fontSize: 15.0,
                          ),),
                        ),),

                      ],
                    )
                  ],
                ),),
              SizedBox(height: 20.0,),
              Divider(height: 2.0,color: Colors.black,thickness: 2.0,),
              SizedBox(height: 8.0,),
              Padding(padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton( shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                        color: Colors.red,
                      ),
                    ),color: Colors.white,padding: EdgeInsets.all(8.0),onPressed: (){
                      //assetAudioPlayer.stop();
                      Navigator.pop(context);
                    },child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),),
                    SizedBox(width: 20.0,),
                    RaisedButton( shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                        color: Colors.green,
                      ),
                    ),color: Colors.green,textColor: Colors.white,onPressed: (){
                      //assetAudioPlayer.stop();
                      checkAvailabilityOfRide(context);
                    },child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),),
                  ],
                ),
              ),SizedBox(height: 10.0,),
            ],
          ),
        ),
      );
    }


    void checkAvailabilityOfRide(context){
          final DatabaseReference newRequestRef=FirebaseDatabase.instance.reference().child("Ride Requests");
      rideRef.once().then((DataSnapshot dataSnapshot) {
        // Navigator.pop(context);
        String theRideID="";
        if(dataSnapshot.value!=null){
          theRideID=dataSnapshot.value.toString();
        }else{
          displayToastMesssage("Ride request doesnt exist", context);
        }
        if(theRideID=="searching"){

          rideRef.set("accepted");

          newRequestRef.once().then((DataSnapshot snapshot) {
            // print('Connected to second database and read ${snapshot.value}');
            //riderDetails RRiderDetails=riderDetails();
            //Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(snapshot.value));
            //List<dynamic> datas = data["Ride Requests"];
            Map<dynamic, dynamic> map = snapshot.value;
            map.values.toList()[0]["driver_id"]="Accepted";
            // newRequestRef.update(map.values.toList()[0]["driver_id"]);
            // print("xxxx"+mapet.toString());
            newRequestRef.set(map);
            print(map.values.toList()[0]["pickup"]['latitude'].toString());
            double pickuplocationlatitude = double.parse(
                map.values.toList()[0]["pickup"]['latitude'].toString());
            double pickuplocationlongitude = double.parse(
                map.values.toList()[0]["pickup"]['longitude'].toString());
            String pickupAddress = map.values.toList()[0]["pickup_address"]
                .toString();
            double dropofflocationlatitude = double.parse(
                map.values.toList()[0]["dropoff"]['latitude'].toString());
            double dropofflocationlongitude = double.parse(
                map.values.toList()[0]["dropoff"]['longitude'].toString());
            String dropoffAddress = map.values.toList()[0]["dropoff_address"]
                .toString();
            String paymentMethod = map.values.toList()[0]["payment_method"]
                .toString();
            String rider_name=map.values.toList()[0]["rider_name"].toString();
            String rider_phone=map.values.toList()[0]["rider_phone"].toString();


            RiderDetails riderDetails = RiderDetails();
            riderDetails.driver_id =
                map.values.toList()[0]["driver_id"].toString();
            print("EEYEYEE" + map.values.toList().toString());
            riderDetails.pickup_address = pickupAddress;
            riderDetails.dropoff_address = dropoffAddress;
            riderDetails.pickup =
                LatLng(pickuplocationlatitude, pickuplocationlongitude);
            // RiderDetails.dropoff=LatLng(dropofflocationlatitude, dropofflocationlongitude);
            riderDetails.payment_method = paymentMethod;
            riderDetails.dropoff=LatLng(dropofflocationlatitude, dropofflocationlongitude);
            riderDetails.rider_name=rider_name;
            riderDetails.rider_phone=rider_phone;

            // print("Information::");
            // print(pickupAddress);
            // print(dropoffAddress);

            if (map.values.toList()[0]["driver_id"].toString() == "Accepted") {
              // showNotification(context);
              // showDialog(context: context,
              //     barrierDismissible: false,
              //     builder: (BuildContext context) =>
              //         NewRideScreen(riderDetails: riderDetails,));
              // Navigator.push(context, MaterialPageRoute(builder: (context) =>
              //     NewRideScreen(riderDetails: riderDetails)));
              print("Kuleshshshshhss");
              // Navigator.of(context).push( MaterialPageRoute(builder: (context)=>NewRideScreen(riderDetails: riderDetails)));
              // Navigator.push(context, MaterialPageRoute(builder: (context) =>
              //     NewRideScreen(riderDetails: riderDetails,)));
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  NewRideScreen(riderDetails: riderDetails,)));
              newRequestRef.remove();
            }});
        }else if(theRideID=="cancelled"){
          displayToastMesssage("ride has been cancelled", context);
        }else if(theRideID=="timeout"){
          displayToastMesssage("ride has timeout", context);
        }else{
          displayToastMesssage("ride does not exist", context);
        }
      });
}}

displayToastMesssage(String message,BuildContext context){
  Fluttertoast.showToast(msg: message);
}
