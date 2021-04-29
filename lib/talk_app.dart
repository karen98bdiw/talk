import 'package:flutter/material.dart';
import 'package:talk/pages/onBoard.dart';
import 'package:talk/pages/sigin_in_screen.dart';
import 'package:talk/pages/sing_up_screen.dart';
import 'package:talk/utils/global_keys.dart';

class TalkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: OnBoard.routeName,
      navigatorKey: navigatorKey,
      routes: {
        OnBoard.routeName: (c) => OnBoard(),
        SignInScreen.routeName: (c) => SignInScreen(),
        SignUpScreen.routeName: (c) => SignUpScreen(),
      },
    );
  }
}
