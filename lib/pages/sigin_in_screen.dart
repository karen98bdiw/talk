import 'package:flutter/material.dart';
import 'package:talk/pages/home.dart';
import 'package:talk/pages/users_screen.dart';
import 'package:talk/services/talk_base.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String email;

  String password;

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  void onSignIn() async {
    _formState.currentState.save();
    var res = await TalkBase().userServices.signIn(
          email: email,
          password: password,
        );

    if (res.errorText == null) {
      print("user signed ");
      Navigator.of(context).push(MaterialPageRoute(builder: (c) => Home()));
    } else {
      print("user not signed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SingIn"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formState,
          child: Column(
            children: [
              TextFormField(
                onSaved: (v) => email = v,
                decoration: InputDecoration(
                  hintText: "email",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onSaved: (v) => password = v,
                decoration: InputDecoration(
                  hintText: "password",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: onSignIn,
                child: Text("sign in"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
