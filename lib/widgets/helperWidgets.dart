import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:talk/pages/sigin_in_screen.dart';
import 'package:talk/pages/sing_up_screen.dart';
import 'package:talk/utils/enums.dart';
import 'package:talk/utils/global_keys.dart';
import 'package:talk/utils/style_helpers.dart';

Widget loginActionChange({LoginAction toAction, BuildContext context}) =>
    RichText(
      text: TextSpan(
        children: [
          TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            text: toAction == LoginAction.SignIn
                ? "Already have account?  "
                : "Don'n have account yet?  ",
          ),
          WidgetSpan(
              child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                toAction == LoginAction.SignIn
                    ? SignInScreen.routeName
                    : SignUpScreen.routeName),
            child: Text(
              toAction == LoginAction.SignIn ? "Sign In" : "Sign Up",
              style: TextStyle(
                  color: lightBlue,
                  decoration: TextDecoration.underline,
                  fontSize: 20),
            ),
          )),
        ],
      ),
    );

showError({String errorText, String title, BuildContext context}) async {
  await showDialog(
    context: context,
    builder: (c) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      insetPadding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                title ?? "Error",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Expanded(
              child: Center(
                child: AutoSizeText(
                  errorText ?? "",
                  maxFontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

showLoading() async {
  await showDialog(
    context: navigatorKey.currentContext,
    builder: (c) => Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      insetPadding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(
              navigatorKey.currentContext,
            ).size.width *
            0.2,
        height: MediaQuery.of(
              navigatorKey.currentContext,
            ).size.height *
            0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              backgroundColor: darkBackground,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "loading...",
              style: TextStyle(
                color: darkBackground,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

hideLoading() {
  navigatorKey.currentState.pop();
}
