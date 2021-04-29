import 'package:flutter/material.dart';
import 'package:talk/models/user.dart';
import 'package:talk/services/talk_base.dart';

class SignUpScreen extends StatelessWidget {
  final user = User();

  String password;

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  void onSignUp() async {
    _formState.currentState.save();
    await TalkBase().userServices.createUser(user: user, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sing up"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formState,
          child: Column(
            children: [
              TextFormField(
                onSaved: (v) => user.nickName = v,
                decoration: InputDecoration(hintText: "nick"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                onSaved: (v) => user.email = v,
                decoration: InputDecoration(hintText: "email"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                onSaved: (v) => password = v,
                decoration: InputDecoration(hintText: "password"),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: onSignUp,
                child: Text("signup"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
