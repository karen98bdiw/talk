import 'package:flutter/material.dart';
import 'package:talk/pages/chats_screen.dart';
import 'package:talk/pages/users_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenIndex == 0 ? "Home Screen" : "Chats Screen"),
      ),
      body: screens[_screenIndex],
      bottomNavigationBar: BottomNavigationBar(
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
            ),
            title: Text("Users"),
            activeIcon: Icon(
              Icons.person,
              color: Colors.pink,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              color: Colors.black,
            ),
            title: Text("Chats"),
            activeIcon: Icon(
              Icons.message,
              color: Colors.pink,
            ),
          ),
        ],
      ),
    );
  }
}
