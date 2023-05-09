import 'package:cando_driver_app/Models/address.dart';
import 'package:cando_driver_app/Models/history.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier{
Address pickUplocation;
Address dropOffLocation;
int countTrips = 0;

void updatePickuplocationAddress(Address pickUpAddress){
  pickUplocation=pickUpAddress;
  notifyListeners();
}
void updateDropOfflocationAddress(Address dropOffAddress){
dropOffLocation=dropOffAddress;
  notifyListeners();
}


String earnings="0";
void updateEarnings(String updatedEarnings){
  earnings=updatedEarnings;
  notifyListeners();
}

List<String>tripHistoryKeys=[];
List<History>TripHistoryDataList=[];
void updateTripscounter(int tripcounter){
  countTrips=tripcounter;
  notifyListeners();
}
void updateTripHistoryKeys(List<String>newKeys){
  tripHistoryKeys=newKeys;
  notifyListeners();
}

void updateTripHistoryData(History history){
  TripHistoryDataList.add(history);
  notifyListeners();
}
}