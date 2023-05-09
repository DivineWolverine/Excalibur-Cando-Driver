
import 'dart:convert';

import 'package:cando_driver_app/Assistants/requestAssistant.dart';
import 'package:cando_driver_app/DataHandler/appData.dart';
import 'package:cando_driver_app/Models/address.dart';
import 'package:cando_driver_app/Models/allUsers.dart';
import 'package:cando_driver_app/Models/directionDetails.dart';
import 'package:cando_driver_app/Models/history.dart';
import 'package:cando_driver_app/configMaps.dart';
import 'package:cando_driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
class AssistantMethods {

  static Future<directionDetails> obtainplacedirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition
        .latitude},${initialPosition.longitude}&destination=${finalPosition
        .latitude},${finalPosition
        .longitude}&key=$mapKey&components=country:lk";
    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "failed") {
      return null;
    }
    directionDetails directiondetailss = directionDetails();
    print(res["routes"][0]["overview_polyline"]["points"]);
    directiondetailss.encodedPoints =
    res["routes"][0]["overview_polyline"]["points"];
    directiondetailss.distanceText =
    res["routes"][0]["legs"][0]["distance"]["text"];
    directiondetailss.distancevalue =
    res["routes"][0]["legs"][0]["distance"]["value"];
    directiondetailss.durationText =
    res["routes"][0]["legs"][0]["duration"]["text"];
    directiondetailss.durationvalue =
    res["routes"][0]["legs"][0]["duration"]["value"];
    return directiondetailss;
  }

  static int calculatefares(directionDetails directionDetailss) {
    double timeTravelledFare = (directionDetailss.durationvalue / 60) * 0.20;
    double distanceTravelledFare = (directionDetailss.distancevalue / 1000) *
        0.20;
    double totalFareAmount = timeTravelledFare + distanceTravelledFare;
    //local currency
    // double totalLocalAmount=totalFareAmount*320;

    if(rideType=="cando-x"){
      double result=(totalFareAmount.truncate())*2.0;
      return result.truncate();
    }else if(rideType=="cando-go"){
      return totalFareAmount.truncate();

    }else if(rideType=="bike"){
      double result=(totalFareAmount.truncate())/2.0;
      return result.truncate();
    }else{
      return totalFareAmount.truncate();
    }

  }

  static void retrieveHistoryinfo(context) {
    //rertieve and dipslay earnings
    driverRef.child(currentFirebaseUser.uid).child("earnings").once().then((
        DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String earnings = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });


    //rertieve and dipslay Trip History
    driverRef.child(currentFirebaseUser.uid).child("history").once().then((
        DataSnapshot datasnapshot) {
      if (datasnapshot.value != null) {
        Map<dynamic, dynamic> keys = datasnapshot.value;
        int tripcounter = keys.length;

        Provider.of<AppData>(context, listen: false).updateTripscounter(
            tripcounter);

        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateTripHistoryKeys(
            tripHistoryKeys);
        obtainTripRequestHistoryData(context);
      }
    });
  }

  static void obtainTripRequestHistoryData(context) {
    // var keys = Provider
    //     .of<AppData>(context, listen: false)
    //     .tripHistoryKeys;
    // for (String key in keys) {
    //   newRequestRef.child(key).once().then((DataSnapshot snapshot) {
    //     if (snapshot.value != null) {
    //       var history = History.fromSnapshot(snapshot);
    //       Provider.of<AppData>(context,listen: false).updateTripHistoryData(history);
    //     }
    //   });
    // }
    // DatabaseReference FinishRequestRef = FirebaseDatabase.instance
    //     .reference().child("Finish");
    print("hello");
    historyRef.orderByChild(currentFirebaseUser.uid).once().then((DataSnapshot snapshot){
      // History fff=History();
      //
      // fff.PaymentMethod="Pay by cash";
      // fff.createdAt="";
      // fff.fare="12";
      // fff.status="onride";
      // fff.dropoff="Borella";
      // fff.pickup="Sigiriya";
      //
      // // var history=Finish.fromSnapshot(fff);
      // Provider.of<AppData>(context,listen: false).updateTripHistoryData(fff);
      if(snapshot.value!=null){
            print("uuuuuu"+snapshot.value.toString());
        Map<dynamic,dynamic>j=snapshot.value;
        for (var i = 0; i <j.length; i++) {
          // if(j.values.toList()[i]["driver_name"]==userCurrentInfo.name){
            History fff=History();
            fff.PaymentMethod=j.values.toList()[i]["payment_method"].toString();
            fff.createdAt=j.values.toList()[i]["created_at"].toString();
            fff.fare=j.values.toList()[i]["fares"].toString();
            fff.status=j.values.toList()[i]["status"].toString();
            fff.dropoff=j.values.toList()[i]["dropoff_address"].toString();
            fff.pickup=j.values.toList()[i]["pickup_address"].toString();

            // fff.PaymentMethod="Pay by cash";
            // fff.createdAt="23 4 2023";
            // fff.fare="12";
            // fff.status="onride";
            // fff.dropoff="Borella";
            // fff.pickup="Sigiriya";

            // var history=Finish.fromSnapshot(fff);
            Provider.of<AppData>(context,listen: false).updateTripHistoryData(fff);

          }}
      // }
    });
  }


  static String formatTripData(String data){
    DateTime dateTime=DateTime.parse(data);
    String formattedDate = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }
 }