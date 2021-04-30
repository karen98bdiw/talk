import 'package:flutter/material.dart';
import 'package:talk/pages/chats_screen.dart';
import 'package:talk/pages/users_screen.dart';
import 'package:talk/utils/style_helpers.dart';
import 'package:talk/widgets/helperWidgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var screens = [
    UsersScreen(),
    ChatsScreen(),
  ];

  var _screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var res = await confirmLogOut(context: context);
        return res;
      },
      child: Scaffold(
        body: screens[_screenIndex],
        bottomNavigationBar: bottomNavigation(),
      ),
    );
  }

  Widget bottomNavigation() => BottomNavigationBar(
        showSelectedLabels: false,
        // selectedLabelStyle: TextStyle(
        //   color: mainBtnColor,
        //   fontSize: 20,
        // ),
        unselectedLabelStyle: TextStyle(
          fontSize: 17,
        ),
        currentIndex: _screenIndex,
        onTap: (i) {
          setState(() {
            _screenIndex = i;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
              size: 40,
            ),
            label: "",
            activeIcon: Icon(
              Icons.person,
              color: mainBtnColor,
              size: 50,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              color: Colors.black,
              size: 40,
            ),
            label: "",
            activeIcon: Icon(
              Icons.message,
              color: mainBtnColor,
              size: 50,
            ),
          ),
        ],
      );
}
