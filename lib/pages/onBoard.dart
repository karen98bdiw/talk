import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talk/pages/home.dart';
import 'package:talk/pages/sigin_in_screen.dart';
import 'package:talk/pages/sing_up_screen.dart';
import 'package:talk/services/talk_base.dart';
import 'package:talk/utils/global_keys.dart';
import 'package:talk/utils/style_helpers.dart';
import 'package:talk/widgets/buttons.dart';
import 'package:talk/widgets/helperWidgets.dart';

class OnBoard extends StatefulWidget {
  static final routeName = "OnBoard";

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  @override
  void initState() {
    checkIfUserSigned();
    super.initState();
  }

  void checkIfUserSigned() async {
    if (FirebaseAuth.instance.currentUser != null) {
      // showLoading(context: context);
      await TalkBase()
          .userServices
          .setCurentUser(userId: FirebaseAuth.instance.currentUser.uid);
      Navigator.of(context).push(MaterialPageRoute(builder: (c) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: darkBackground,
        padding: formScaffoldPadding,
        child: LayoutBuilder(
          builder: (c, cn) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: cn.maxHeight,
                minWidth: cn.maxWidth,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Talk...",
                    style: titleStyle(isLight: false),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SvgPicture.asset(
                    "assets/images/logo.svg",
                    width: MediaQuery.of(context).size.height * 0.3,
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  actions(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget actions(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomBtn(
            title: "Sign In",
            onClick: () {
              Navigator.of(context).pushNamed(SignInScreen.routeName);
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomBtn(
            outlined: true,
            outlineColor: Colors.white,
            textColor: Colors.white,
            title: "Sign Up",
            onClick: () {
              Navigator.of(context).pushNamed(SignUpScreen.routeName);
            },
          ),
        ],
      );
}
