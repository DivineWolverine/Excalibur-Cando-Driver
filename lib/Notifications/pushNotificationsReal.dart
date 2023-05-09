import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cando_driver_app/Models/riderDetails.dart';
import 'package:cando_driver_app/Notifications/notificationDialog.dart';
import 'package:cando_driver_app/configMaps.dart';
import 'package:cando_driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class PushNotificationServiceReal {

  AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();



  Future initialize(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        // retrieveRideRequestInfo(getRideRequestId(message),context);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {

      }
    });
  }

  void showNotification(BuildContext context) {
    flutterLocalNotificationsPlugin.show(
        0,
        "New Ride Request",
        "You have a Ride Request!!! Accept And Start Ride!!!",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));




  }
  void sam(BuildContext context){
    final DatabaseReference newRequestRef=FirebaseDatabase.instance.reference().child("Ride Requests");

    newRequestRef.once().then((DataSnapshot snapshot) {
      final assetAudioPlayer=AssetsAudioPlayer();
      assetAudioPlayer.open(Audio("sounds/alert.mp3"));
      assetAudioPlayer.play();
      print('Connected to second database and read ${snapshot.value}');
      //riderDetails RRiderDetails=riderDetails();
      //Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(snapshot.value));
      //List<dynamic> datas = data["Ride Requests"];
      Map<dynamic, dynamic> map = snapshot.value;
      print(map.values.toList()[0]["pickup"]['latitude'].toString());
      double pickuplocationlatitude=double.parse(map.values.toList()[0]["pickup"]['latitude'].toString());
      double pickuplocationlongitude=double.parse(map.values.toList()[0]["pickup"]['longitude'].toString());
      String pickupAddress=map.values.toList()[0]["pickup_address"].toString();
      double dropofflocationlatitude=double.parse(map.values.toList()[0]["dropoff"]['latitude'].toString());
      double dropofflocationlongitude=double.parse(map.values.toList()[0]["dropoff"]['latitude'].toString());
      String dropoffAddress=map.values.toList()[0]["dropoff_address"].toString();
      String paymentMethod=map.values.toList()[0]["payment_method"].toString();
      String rider_name=map.values.toList()[0]["rider_name"].toString();
      String rider_phone=map.values.toList()[0]["rider_phone"].toString();

      RiderDetails riderDetails=RiderDetails();
      riderDetails.driver_id=map.values.toList()[0]["driver_id"].toString();
      print("EEYEYEE"+map.values.toList().toString());
      riderDetails.pickup_address=pickupAddress;
      riderDetails.dropoff_address=dropoffAddress;
      riderDetails.pickup=LatLng(pickuplocationlatitude, pickuplocationlongitude);
      // RiderDetails.dropoff=LatLng(dropofflocationlatitude, dropofflocationlongitude);
      riderDetails.payment_method=paymentMethod;
      riderDetails.rider_name=rider_name;
      riderDetails.rider_phone=rider_phone;
      print("Information::");
      print(pickupAddress);
      print(dropoffAddress);

      if(map.values.toList()[0]["driver_id"].toString()=="waiting"){
        showNotification(context);
        showDialog(context: context, barrierDismissible:false,builder: (BuildContext context)=>NotificationDialog(riderDetails: riderDetails,));
          // Navigator.pop(context);
      }else{
        // assetAudioPlayer.stop();
          Navigator.pop(context);
      }
    });
  }



}