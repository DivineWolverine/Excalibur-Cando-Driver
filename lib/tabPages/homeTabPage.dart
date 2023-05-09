import 'dart:async';

import 'package:cando_driver_app/Assistants/assistantMethods.dart';
import 'package:cando_driver_app/Models/riderDetails.dart';
import 'package:cando_driver_app/Models/drivers.dart';
import 'package:cando_driver_app/Models/riderDetails.dart';
import 'package:cando_driver_app/Notifications/pushNotificationsReal.dart';
import 'package:cando_driver_app/configMaps.dart';
import 'package:cando_driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget{
  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
Completer<GoogleMapController>_controllerGoogleMap=Completer();

GoogleMapController newGoogleMapController;
Position currentPosition;

var geolocator=Geolocator();

String DriverStatusText="Offline Now Go Online";

Color driverstatusColor=Colors.black;

bool isDriverAvailable=false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getCurrentDriverInfo();
    });
  }
void locationPosition()async{
  Position position=await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
  );
  currentPosition=position;
  LatLng latLatPosition=LatLng(position.latitude, position.longitude);
  CameraPosition cameraPosition=new CameraPosition(target: latLatPosition,zoom: 14);
  newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition
  ));

}
void getRatings(){
  //update Ratings
  driverRatingsRef.child(currentFirebaseUser.uid).child("ratings").once().then((DataSnapshot snapshot){
    if(snapshot.value!=null){
      double ratings=double.parse(snapshot.value.toString());
      starCounter=ratings;

      if(starCounter == 1.0)
      {
        setState(() {
          title = "Very Bad";
          return;
        });


      }
      if(starCounter == 2.0)
      {

        setState(() {
          title = "Bad";
          return;
        });
      }
      if(starCounter == 3.0)
      {
        setState(() {

          title = "Good";
          return;
        });
      }
      if(starCounter == 4.0)
      {

        setState(() {
          title = "Very Good";
          return;
        });
      }
      if(starCounter == 5.0)
      {

        setState(() {
          title = "Excellent";
          return;
        });
      }
    }
    // else{
    //   setState(() {
    //     title="Excellent";
    //     return;
    //   });
    // }
  });
}

void getRideType(){
  driverRef.child(currentFirebaseUser.uid).child("car_details").child("type").once().then((DataSnapshot snapshot){
    if(snapshot.value!=null){
      setState(() {
        rideType=snapshot.value.toString();
      });
    }
  }
  );
}
void getCurrentDriverInfo()async{
  currentFirebaseUser=await FirebaseAuth.instance.currentUser;
  // driverRef.child(currentFirebaseUser.uid).once().then((DataSnapshot dataSnapshot) =>
  // driversInformation=Drivers.fromSnapshot(DataSnapshot datasnapshot){});
  driverRef.child(currentFirebaseUser.uid).once().then((DataSnapshot datasnapshot){
    driversInformation=Drivers.fromSnapshot(datasnapshot);
  });
  PushNotificationServiceReal pushNotificationService=PushNotificationServiceReal();
  pushNotificationService.initialize(context);


  pushNotificationService.sam(context);
AssistantMethods.retrieveHistoryinfo(context);
getRatings();
getRideType();
}

final CameraPosition _kGooglePlex=CameraPosition(target:
LatLng(6.927079,79.861244),zoom: 14.4746);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        GoogleMap(mapType: MapType.normal,myLocationButtonEnabled: true,
          myLocationEnabled: true,

          initialCameraPosition: _kGooglePlex,onMapCreated: (GoogleMapController controller){
            _controllerGoogleMap.complete(controller);
            newGoogleMapController=controller;

            locationPosition();
          },),
        //online offline driver Container
        Container(
          height: 140.0,width: double.infinity,color: Colors.black54,
        ),
        Positioned(top: 60.0,left: 0.0,right: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 16.0,),
              child: RaisedButton(
                onPressed: (){
                  if(isDriverAvailable!=true){
                    makeDriverOnlineNow();
                    getLocationLiveUpdate();
                    setState(() {
                      driverstatusColor=Colors.green;
                      DriverStatusText="Online Now";
                      isDriverAvailable=true;
                    });
                    displayToastMesssage("You are online now", context);
                  }else{
                    setState(() {
                      driverstatusColor=Colors.black;
                      DriverStatusText="Offline Now Go Online";
                      isDriverAvailable=false;
                    });
                       makeDriverOfflineNow();
                    displayToastMesssage("You are offline now", context);

                  }

                },
                color: driverstatusColor,
                child: Padding(padding: EdgeInsets.all(7.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DriverStatusText,style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,

                      ),),
                      Icon(Icons.phone_android,color: Colors.white,size: 26.0,),
                    ],
                  ),),
              ),),

          ],
        ),
        ),
      ],
    );
  }

void makeDriverOnlineNow()async{
    Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition=position;
    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
    rideRef.set("searching");
    rideRef.onValue.listen((event){});
}

void getLocationLiveUpdate(){
    homeTabPageStreamSubscription=Geolocator.getPositionStream().listen((Position position) {currentPosition=position;
  currentPosition=position;
   if(isDriverAvailable==true){
     Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);

   }

   LatLng latLng=LatLng(position.latitude, position.longitude);
   newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));

    });
}
displayToastMesssage(String message,BuildContext context){
  Fluttertoast.showToast(msg: message);
}
void makeDriverOfflineNow(){
    Geofire.removeLocation(currentFirebaseUser.uid);
    rideRef.onDisconnect();
    rideRef.remove();
    rideRef=null;
    displayToastMesssage("You are offline now", context);
}



}
