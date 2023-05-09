import 'package:cando_driver_app/tabPages/earningsTabPage.dart';
import 'package:cando_driver_app/tabPages/homeTabPage.dart';
import 'package:cando_driver_app/tabPages/profileTabPage.dart';
import 'package:cando_driver_app/tabPages/ratingtabpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  static const String idScreen="mainscreen";
  @override
  MainScreenState createState() => MainScreenState();
}
 class MainScreenState extends State<Mainscreen> with SingleTickerProviderStateMixin{
  TabController tabController;
  int selectedIndex=0;
  void onItemClicked(int index) {
    setState(() {
      selectedIndex=index;
      tabController.index=selectedIndex;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController=TabController(length: 4, vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
      physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
        HomeTabPage(),
        EarningsTabPage(),
          RatingTabPage(),
          profileTabPage(),
        ],
      ),bottomNavigationBar: BottomNavigationBar(
      items:<BottomNavigationBarItem> [
        BottomNavigationBarItem(icon: Icon(Icons.home,),label: "Home",),
        BottomNavigationBarItem(icon: Icon(Icons.credit_card,),label: "Earnings",),
        BottomNavigationBarItem(icon: Icon(Icons.star,),label: "Ratings",),
        BottomNavigationBarItem(icon: Icon(Icons.person,),label: "Account",),

      ],unselectedItemColor: Colors.black54,
      selectedItemColor: Colors.yellow,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12.0),
      showUnselectedLabels: true,
      onTap: onItemClicked,
    ),
    );
  }

 }

