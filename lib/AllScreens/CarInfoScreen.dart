import 'package:cando_driver_app/AllScreens/MainScreen.dart';
import 'package:cando_driver_app/configMaps.dart';
import 'package:cando_driver_app/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarInfoScreen extends StatelessWidget{
static const String idScreen="carinfo";
TextEditingController carModelTextEditingcontroller=TextEditingController();
TextEditingController carNumberTextEditingcontroller=TextEditingController();
TextEditingController carColorTextEditingcontroller=TextEditingController();
String selectCarType;
List<String>cartypelist=["cando-x","cando-go","bike"];

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: SafeArea(
       child: SingleChildScrollView(
         child: Column(
           children: [
             SizedBox(height: 22.0,),
             Image.asset("images/logo.png",width: 300.0,
             height: 250.0,),
             Padding(padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),child:
               Column(
                 children: [
                   SizedBox(height: 12.0,),
                   Text("Enter Car details",style: TextStyle(
                     fontFamily: "Brand-Bold",
                     fontSize: 24.0,
                   ),),
                   SizedBox(height: 26.0,),
                   TextField(
                     controller: carModelTextEditingcontroller,
                     decoration: InputDecoration(
                       labelText: "Car Model",hintStyle: TextStyle(
                       color: Colors.grey,
                       fontSize: 10.0,

                     ),

                     ),style: TextStyle(
                     fontSize: 15.0,
                   ),
                   ),
                   SizedBox(height: 10.0,),
                   TextField(
                     controller:carNumberTextEditingcontroller,
                     decoration: InputDecoration(
                       labelText: "Car number",hintStyle: TextStyle(
                       color: Colors.grey,
                       fontSize: 10.0,

                     ),

                     ),style: TextStyle(
                     fontSize: 15.0,
                   ),
                   ),
                   SizedBox(height: 10.0,),
                   TextField(
                     controller: carColorTextEditingcontroller,
                     decoration: InputDecoration(
                       labelText: "Car Color",hintStyle: TextStyle(
                       color: Colors.grey,
                       fontSize: 10.0,

                     ),

                     ),style: TextStyle(
                     fontSize: 15.0,
                   ),
                   ),

                   SizedBox(height: 26.0,),
                   DropdownButton(iconSize: 40,hint:Text("Please Choose Car Type"),value: selectCarType,onChanged: (newvalue){
                     selectCarType=newvalue;
                     displayToastMesssage(selectCarType, context);
                   }, items: cartypelist.map((car) {
                     return DropdownMenuItem(
                       child: new Text(car),
                       value: car,
                     );
                   }).toList(),
                   ), SizedBox(height: 42.0,),
                   Padding(padding:
                   EdgeInsets.symmetric(horizontal: 16.0),
                   child: RaisedButton(
                     onPressed: (){
                       if(carModelTextEditingcontroller.text.isEmpty){
                         displayToastMesssage("Please write car model", context);

                       }else if(carNumberTextEditingcontroller.text.isEmpty){
                         displayToastMesssage("Please write car number", context);
                       }else if(carColorTextEditingcontroller.text.isEmpty){
                         displayToastMesssage("Please write car color", context);

                       }else if(selectCarType==null){
                         displayToastMesssage("Please select car type", context);
                       }

                       else{
                         saveDriverCarInfo(context);
                       }
                     },color: Theme.of(context).accentColor
                     ,
                     child: Padding(
                       padding: EdgeInsets.all(17.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("NEXT",style: TextStyle(
                             fontSize: 20.0,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,

                           ),),
                           Icon(Icons.arrow_forward, color: Colors.white,size: 26.0,),

                         ],
                       ),
                     ),
                   ),),

                 ],
               ),),
           ],
         ),
       ),
     ),
   );
       
  }
void saveDriverCarInfo(context){
    String userid=currentFirebaseUser.uid;
    Map carInfoMapas={
      "car_color":carColorTextEditingcontroller.text,
      "car_number":carNumberTextEditingcontroller.text,
      "car_model":carModelTextEditingcontroller.text,
      "type":selectCarType,
    };
    driverRef.child(userid).child("car_details").set(carInfoMapas);
    Navigator.pushNamedAndRemoveUntil(context, Mainscreen.idScreen, (route) => false);
  }

displayToastMesssage(String message,BuildContext context){
  Fluttertoast.showToast(msg: message);
}
}