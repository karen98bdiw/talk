import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:talk/models/user.dart';
import 'package:talk/services/talk_base.dart';
import 'package:talk/utils/enums.dart';
import 'package:talk/utils/helpers.dart';
import 'package:talk/utils/style_helpers.dart';
import 'package:talk/widgets/buttons.dart';
import 'package:talk/widgets/helperWidgets.dart';
import 'package:talk/widgets/inputs.dart';

class SignUpScreen extends StatefulWidget {
  static final routeName = "SignUpScreen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final user = User();

  String password;

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  void _onSignUp() async {
    if (!_formState.currentState.validate()) return;
    _formState.currentState.save();
    showLoading();
    var res = await TalkBase()
        .userServices
        .createUser(user: user, password: password);
    hideLoading();
    if (res.errorText == null) {
      print("user signed up");
    } else {
      showError(errorText: res.errorText, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        body: Container(
          color: lightBackground,
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
                      "Sign In",
                      style: titleStyle(isLight: true),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    signInForm(),
                    SizedBox(
                      height: 10,
                    ),
                    action(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget action() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomBtn(
            title: "Sign Up",
            onClick: _onSignUp,
          ),
          SizedBox(
            height: 10,
          ),
          loginActionChange(toAction: LoginAction.SignIn, context: context),
        ],
      );

  Widget signInForm() => Form(
      key: _formState,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomFormInput(
            hint: "Nick name",
            validator: (v) => v.isEmpty ? "Nick Name is required" : null,
            onSaved: (v) => user.nickName = v,
          ),
          CustomFormInput(
            hint: "E-Mail",
            validator: (v) => emailValidator(v),
            onSaved: (v) => user.email = v,
          ),
          CustomFormInput(
            obscureText: true,
            hint: "Password",
            onSaved: (v) => password = v,
            validator: (v) => passwordValidator(v),
          ),
        ],
      ));
}
