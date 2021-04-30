import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:talk/pages/sigin_in_screen.dart';
import 'package:talk/pages/sing_up_screen.dart';
import 'package:talk/services/talk_base.dart';
import 'package:talk/talk_app.dart';
import 'package:talk/utils/enums.dart';
import 'package:talk/utils/global_keys.dart';
import 'package:talk/utils/style_helpers.dart';
import 'package:talk/widgets/buttons.dart';

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

showLoading({BuildContext context}) async {
  await showDialog(
    barrierDismissible: false,
    context: context ?? navigatorKey.currentContext,
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

hideLoading({BuildContext context}) {
  if (context != null) {
    Navigator.of(context).pop();
  } else {
    navigatorKey.currentState.pop();
  }
}

Future<bool> exitFromAppConfirmation(BuildContext context) async {
  var res = await showDialog(
    context: context,
    builder: (c) => Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Looks like you want to exit app?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomBtn(
                      title: "No",
                      onClick: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomBtn(
                      title: "Yes",
                      onClick: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );

  return res ?? false;
}

Future<bool> confirmLogOut({BuildContext context}) async {
  var res = await showDialog(
    context: context,
    builder: (c) => Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Looks like you want to log out?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomBtn(
                      title: "No",
                      onClick: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomBtn(
                      title: "Yes",
                      onClick: () async {
                        await TalkBase().userServices.logOut();

                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );

  return res ?? false;
}
