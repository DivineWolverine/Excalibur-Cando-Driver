import 'dart:async';

import 'package:cando_driver_app/Models/AllRider.dart';
import 'package:cando_driver_app/Models/allUsers.dart';
import 'package:cando_driver_app/Models/drivers.dart';
import 'package:cando_driver_app/Models/riderDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

String mapKey="AIzaSyB8gHnZ83HcD5_XNtl7PCpIXvWlNuz0G50";
User firebaseuser;
Users userCurrentInfo;
User currentFirebaseUser;
StreamSubscription<Position> homeTabPageStreamSubscription;
StreamSubscription<Position> rideStreamSubscription;
Drivers driversInformation;
Position currentPosition;
AllRider allRider;
RiderDetails riderDetails;
String title="";
double starCounter=0.0;
String rideType="";