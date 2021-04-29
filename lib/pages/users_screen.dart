import 'package:flutter/material.dart';
import 'package:talk/models/chat.dart';
import 'package:talk/models/user.dart';
import 'package:talk/services/talk_base.dart';
import 'package:talk/talk_app.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> allUser = [];

  @override
  void initState() {
    getAllUsers();

    super.initState();
  }

  void getAllUsers() async {
    var res = await TalkBase().userServices.getAllUsers();

    if (res.data.length > 0) {
      setState(() {
        allUser = res.data;
      });
    } else {
      print("users not fined");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                itemBuilder: (c, i) => ListTile(
                  onTap: () async {
                    await TalkBase().chatServices.createChat(
                      chatUsers: [
                        allUser[i],
                        TalkBase().userServices.curentUser
                      ],
                    );
                  },
                  title: Text(allUser[i].nickName),
                  subtitle: Text(allUser[i].email),
                ),
                itemCount: allUser.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
