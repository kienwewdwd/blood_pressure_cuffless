import 'package:blood_pressure/Screen/DashScreen.dart';
import 'package:blood_pressure/Screen/Profile_screen.dart';
import 'package:blood_pressure/constrants.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    // final tabs = [const DashboardScreen(), HomePage11()];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                color: CustomColors.kPrimaryColor, size: 30),
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => const HomePage11()),
              );
            }),
        title: Text(
          "Blood Pressure",
          style: TextStyle(
              color: CustomColors.kPrimaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        // title: SvgPicture.asset(
        //   'Images/assets/icons/blood-pressure-icon.svg',
        //   height: 45,
        //   color: CustomColors.kPrimaryColor,

        // ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.arrow_forward_ios,
        //         color: CustomColors.kPrimaryColor, size: 30),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => const HomePage11()),
        //       );
        //     }
        //     ),
        // ],
      ),
      body: DashboardScreen(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.shifting,
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       // _currentIndex = index;
      //     });
      //   },
      //   selectedItemColor: CustomColors.kPrimaryColor,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: SvgPicture.asset(
      //         'Images/assets/icons/apps.svg',
      //         height: 30,
      //         color: Colors.grey,
      //       ),
      //       label: 'Activity',
      //       activeIcon: SvgPicture.asset(
      //         'Images/assets/icons/apps.svg',
      //         height: 30,
      //         color: CustomColors.kPrimaryColor,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: SvgPicture.asset(
      //         'Images/assets/icons/stats.svg',
      //         height: 30,
      //         color: Colors.grey,
      //       ),
      //       label: 'Stats',
      //       activeIcon: SvgPicture.asset(
      //         'Images/assets/icons/stats.svg',
      //         height: 30,
      //         color: CustomColors.kPrimaryColor,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
