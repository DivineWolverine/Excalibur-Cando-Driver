import 'package:cando_driver_app/AllScreens/CarInfoScreen.dart';
import 'package:cando_driver_app/AllScreens/HistoryScreen.dart';
import 'package:cando_driver_app/AllScreens/MainScreen.dart';
import 'package:cando_driver_app/AllScreens/CarInfoScreen.dart';
import 'package:cando_driver_app/AllScreens/NewRideScreen.dart';
import 'package:cando_driver_app/AllScreens/loginScreen.dart';
import 'package:cando_driver_app/AllScreens/newRideScreen.dart';
import 'package:cando_driver_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cando_driver_app/AllScreens/RegistrationScreen.dart';
import 'package:provider/provider.dart';
import 'package:cando_driver_app/DataHandler/appData.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentFirebaseUser=FirebaseAuth.instance.currentUser;
runApp(new MyApp());
}
DatabaseReference userRef=FirebaseDatabase.instance.reference().child("users");
DatabaseReference driverRef=FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference newRequestRef=FirebaseDatabase.instance.reference().child("Ride Requests");
DatabaseReference historyRef=FirebaseDatabase.instance.reference().child("history");
DatabaseReference rideRef=FirebaseDatabase.instance.reference().child("drivers").child(currentFirebaseUser.uid).child("newRide");
DatabaseReference driverRatingsRef=FirebaseDatabase.instance.reference().child("driverRatings");
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return ChangeNotifierProvider(
     create: (context)=> AppData(),
     child: MaterialApp(
       title: "Taxi Driver App",
       theme: ThemeData(
         fontFamily: "Brand-Bold",
         primarySwatch: Colors.blue,
         visualDensity: VisualDensity.adaptivePlatformDensity,
       ),
       initialRoute:FirebaseAuth.instance.currentUser==null?LoginScreen.idScreen:Mainscreen.idScreen,
       routes: {
         RegistrationScreen.idScreen:(context)=>RegistrationScreen(),
         LoginScreen.idScreen:(context)=>LoginScreen(),
         Mainscreen.idScreen:(context)=>Mainscreen(),
         CarInfoScreen.idScreen:(context)=> CarInfoScreen(),
        HistoryScreen.idScreen:(context)=>HistoryScreen(),
        },
       debugShowCheckedModeBanner: false,
     ),
   );
  }

}