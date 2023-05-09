import 'dart:async';


import 'package:cando_driver_app/AllWidgets/CollectFareDialog.dart';
import 'package:cando_driver_app/AllWidgets/progressDialog.dart';
import 'package:cando_driver_app/Assistants/assistantMethods.dart';
import 'package:cando_driver_app/Assistants/maptoolKitAssistant.dart';
import 'package:cando_driver_app/Models/riderDetails.dart';
import 'package:cando_driver_app/configMaps.dart';
import 'package:cando_driver_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class NewRideScreen extends StatefulWidget {

  final RiderDetails riderDetails;
  NewRideScreen({this.riderDetails});
  static final CameraPosition _kGooglePlex = CameraPosition(
    //target: LatLng(37.42796133580664, -122.085749655962),
    target: LatLng(6.9271, 79.8612),

    zoom: 14.4746,
  );


  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController _newRideGoogleMapController;
  Set<Marker>markerSet=Set<Marker>();
  Set<Circle>CircleSet=Set<Circle>();
  Set<Polyline>polylineSet=Set<Polyline>();
  List<LatLng>polylineCoordinates=[];
  PolylinePoints polylinePoints=PolylinePoints();
  double mappaddingFromBottom=0;
  var geolocator=Geolocator();
  var locationOption=LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor animatingMarkericon;
  Position myposition;
  String status="accepted";
  String durationRide="";
  bool isRequestingDirection=false;
  String btnTitle="Arrived";
  Color btnColor=Colors.blueAccent;
  Timer timer;
  int durationCounter=0;
@override
  void initState() {
  acceptRideRequests();
    super.initState();
  }
  void createIconMarker(){
    if(animatingMarkericon==null){
      ImageConfiguration imageConfiguration=createLocalImageConfiguration(context,size: Size(2,2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_ios.png").then((value) {animatingMarkericon=value;});
    }
  }
  @override
  Widget build(BuildContext context) {
createIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mappaddingFromBottom),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: NewRideScreen._kGooglePlex,
            myLocationEnabled: true,
            markers: markerSet,
            circles: CircleSet,
            polylines: polylineSet,
            onMapCreated: (GoogleMapController controller)async{
              _controllerGoogleMap.complete(controller);
              _newRideGoogleMapController=controller;
              setState(() {
                mappaddingFromBottom=265.0;
              });


              var currentLatlng=widget.riderDetails.dropoff;

              var pickupLatlng=widget.riderDetails.pickup;
              // print(dropoffLatlng);
              print('pickuppp'+pickupLatlng.toString());
              print("dropoff"+currentLatlng.toString());
              await getPlaceDirection(currentLatlng, pickupLatlng);
              getRideLiveLocationUpdates();
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(16.0)  ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,0.7,
                    ),
                  ),
                ],
              ),
              height: 290.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                child: Column(
                  children: [
                    Text(durationRide,style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: "Brand-Bold",
                      color: Colors.deepPurple,
                    ),),
                    SizedBox(height: 6.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.riderDetails.rider_name,style: TextStyle(
                          fontFamily: "Brand-Bold",
                          fontSize: 24.0,

                        ),),
                        Padding(padding: EdgeInsets.only(right:10.0),
                          child: Icon(Icons.phone_android),),

                      ],
                    ),
                    SizedBox(height: 26.0,),
                    Row(
                      children: [
                        Image.asset("images/pickicon.png",height: 16.0,width: 16.0,),
                        SizedBox(width: 18.0,),
                        Expanded(child:Container(
                          child: Text(
                            widget.riderDetails.pickup_address,style: TextStyle(
                            fontSize: 18.0,
                          ),
                            overflow: TextOverflow.ellipsis,

                          ),
                        ),),
                      ],
                    ),
                    SizedBox(height: 16.0,),
                    Row(
                      children: [
                        Image.asset("images/desticon.png",height: 16.0,width: 16.0,),
                        SizedBox(width: 18.0,),
                        Expanded(child:Container(
                          child: Text(
                            widget.riderDetails.dropoff_address,style: TextStyle(
                            fontSize: 18.0,
                          ),
                            overflow: TextOverflow.ellipsis,

                          ),
                        ),),
                      ],
                    ),
                    SizedBox(height: 26.0,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: ()async{
                          // DatabaseReference newRequestRef=FirebaseDatabase.instance.reference().child("Ride Requests");

                          if(status=="accepted"){
                            status="arrived";
                            String rideReuqestID=driversInformation.id;
                            newRequestRef.child(rideReuqestID).child("status").set(status);

                            setState(() {
                              btnTitle="Start Trip";
                              btnColor=Colors.deepOrange;
                            });
                            showDialog(context: context,barrierDismissible: false, builder:(BuildContext context)=>ProgressDialog(message: "Please wait..",));
                            await getPlaceDirection(widget.riderDetails.pickup, widget.riderDetails.dropoff);
                            Navigator.pop(context);
                          }else if(status=="arrived"){
                            status="onride";
                            String rideReuqestID=driversInformation.id;

                            newRequestRef.child(rideReuqestID).child("status").set(status);
                            setState(() {
                              btnTitle="End Trip";
                              btnColor=Colors.purple;
                            });
                            initTimer();
                          }else if(status=="onride"){
                            entheTrip();
                          }
                        },
                        color: btnColor,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(btnTitle,style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),

                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> getPlaceDirection(LatLng pickUpLatLng, LatLng dropOffLatLng) async
  {

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
    );

    var details = await AssistantMethods.obtainplacedirectionDetails(pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);

    print("This is Encoded Points ::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);

    polylineCoordinates.clear();

    if(decodedPolyLinePointsResult.isNotEmpty)
    {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polylineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points:polylineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if(pickUpLatLng.latitude > dropOffLatLng.latitude  &&  pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    else if(pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    }
    else if(pickUpLatLng.latitude > dropOffLatLng.latitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    }
    else
    {
      latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    _newRideGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markerSet.add(pickUpLocMarker);
      markerSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.deepPurple,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      CircleSet.add(pickUpLocCircle);
      CircleSet.add(dropOffLocCircle);
    });
  }
void acceptRideRequests(){
    // String rideReuqestId=widget.riderDetails.ride_request_id;
    String rideReuqestId=driversInformation.id;


    DatabaseReference newRequestRef=FirebaseDatabase.instance.reference().child("Ride Requests");
 newRequestRef.child(rideReuqestId).child("status").set("accepted");
    newRequestRef.child(rideReuqestId).child("driver_name").set(driversInformation.name);
newRequestRef.child(rideReuqestId).child("driver_phone").set(driversInformation.phone);
    newRequestRef.child(rideReuqestId).child("driver_id").set(driversInformation.id);
    newRequestRef.child(rideReuqestId).child(rideReuqestId).child("car_details").set('${driversInformation.car_color}-${driversInformation.car_number}-${driversInformation.car_number}');
    Map locMap={
      "latitude":widget.riderDetails.pickup.latitude,
      "longitude":widget.riderDetails.pickup.longitude,
    };
    newRequestRef.child(rideReuqestId).child("drivers_location").set(locMap);
    DatabaseReference driverRef=FirebaseDatabase.instance.reference().child("drivers");
    driverRef.child(currentFirebaseUser.uid).child("history").child(rideReuqestId).set(true);


}

  void getRideLiveLocationUpdates(){
    LatLng oldPos=LatLng(0, 0);
    rideStreamSubscription=Geolocator.getPositionStream().listen((Position position){
      currentPosition=position;
      myposition=position;

      LatLng mPosition=LatLng(position.latitude, position.longitude);
      var rot=maptoolKitAssistant.getMarkerRotation(oldPos.latitude, oldPos.longitude, myposition.latitude, myposition.longitude);

      Marker animatingMarker=Marker(markerId: MarkerId("animating"),position: mPosition,icon: animatingMarkericon,rotation: rot,
          infoWindow: InfoWindow(title: "Current Location"));
      setState(() {
        CameraPosition cameraPosition=new CameraPosition(target: mPosition,zoom:17 );
        _newRideGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        markerSet.removeWhere((marker) => marker.markerId.value=="animating");
        markerSet.add(animatingMarker);
      });
      oldPos=mPosition;
      updateRiderDetails();
      String riderquestID=widget.riderDetails.ride_request_id;
      DatabaseReference newRequestRef=FirebaseDatabase.instance.reference().child("Ride Requests");

      Map locMap={
        "latitude":widget.riderDetails.pickup.latitude,
        "longitude":widget.riderDetails.pickup.longitude,
      };


      newRequestRef.child(riderquestID).child("driver_location").set(locMap);


    });

   }
  void updateRiderDetails()async{
    if(isRequestingDirection==false){
      isRequestingDirection=true;

      if(myposition==null){
        return;
      }
      var posLatLng=LatLng(myposition.latitude, myposition.longitude);
      LatLng destinationLatlng;
      if(status=="accepted"){
        destinationLatlng=widget.riderDetails.pickup;


      }else{
        destinationLatlng=widget.riderDetails.dropoff;
      }
      var directionDetails=await AssistantMethods.obtainplacedirectionDetails(posLatLng,destinationLatlng);
      print("directions"+directionDetails.durationText);
      if(directionDetails!=null){
        setState(() {
          durationRide=directionDetails.durationText;
          // durationRide="10mins";
        });

      }isRequestingDirection=false;
    }
  }
void initTimer(){
  const interval=Duration(seconds: 1);
  timer=Timer.periodic(interval, (timer) {durationCounter=durationCounter+1;});
}
void entheTrip()async{
  timer.cancel();
  DatabaseReference newRequestRef=FirebaseDatabase.instance.reference().child("Ride Requests");

  showDialog(context: context, barrierDismissible:false,builder: (BuildContext context)=>ProgressDialog(message: "Please Wait..",));
  var currentLatLng=LatLng(myposition.latitude, myposition.longitude);
  var directionDetails=await AssistantMethods.obtainplacedirectionDetails(widget.riderDetails.pickup, currentLatLng);
  Navigator.pop(context);
  int fareAmount=AssistantMethods.calculatefares(directionDetails);
  String rideRequestId=driversInformation.id;
  newRequestRef.child(rideRequestId).child("fares").set(fareAmount.toString());
  newRequestRef.child(rideRequestId).child("status").set("ended");
  DateTime now=new DateTime.now();
  DateTime date=new DateTime(now.year,now.month,now.day);
  Map historyMap={
    "payment_method": "cash or card",
    "created_at":date.toString(),
    "fares":fareAmount.toString(),
    "status":"ended",
    "dropoff_address":widget.riderDetails.dropoff_address.toString(),
    "pickup_address":widget.riderDetails.pickup_address.toString(),
  };
  historyRef.child(currentFirebaseUser.uid).set(historyMap);

  rideStreamSubscription.cancel();
  showDialog(context: context, barrierDismissible:false,builder:(BuildContext context)=>CollectFareDialog(paymentMethod: widget.riderDetails.payment_method,fareAmount: fareAmount,),
  );
  saveEarnings(fareAmount);

}
  void saveEarnings(int fareAmount){
    driverRef.child(currentFirebaseUser.uid).child("earnings").once().then((DataSnapshot dataSnapShot){

      if (dataSnapShot.value != null) {
        double oldEarnings=double.parse(dataSnapShot.value.toString());

        double totalEarnings = fareAmount+oldEarnings;

        driverRef.child(currentFirebaseUser.uid).child("earnings").set(totalEarnings.toStringAsFixed(2));
      }else{
        double totalEarnings=fareAmount.toDouble();
        driverRef.child(currentFirebaseUser.uid).child("earnings").set(
            totalEarnings.toStringAsFixed(2));
      }
    });
  }
}

