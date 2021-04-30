import 'package:flutter/material.dart';
import 'package:talk/models/user.dart';
import 'package:talk/services/talk_base.dart';
import 'package:talk/utils/helpers.dart';
import 'package:talk/utils/style_helpers.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: formScaffoldPadding,
            child: Column(
              children: [
                curentUserInfo(),
                SizedBox(
                  height: 20,
                ),
                allUserInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget allUserInfo() => Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          border: Border.all(width: 1, color: mainBorderColor),
        ),
        height: MediaQuery.of(context).size.height * 0.5,
        child: ListView.separated(
          separatorBuilder: (c, i) => Divider(
            thickness: 2,
          ),
          itemBuilder: (c, i) => ListTile(
            onTap: () async {
              await TalkBase().chatServices.createChat(
                chatUsers: [allUser[i], TalkBase().userServices.curentUser],
              );
            },
            trailing: CircleAvatar(
              radius: 5,
              backgroundColor: Colors.green,
            ),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  NetworkImage(allUser[i].imageLink ?? dummyUserImage),
            ),
            title: Text(allUser[i].nickName),
            subtitle: Text(allUser[i].email),
          ),
          itemCount: allUser.length,
        ),
      );

  Widget curentUserInfo() {
    print(TalkBase().userServices.curentUser.toJson());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.grey[300],
          backgroundImage: NetworkImage(
            TalkBase().userServices.curentUser.imageLink ?? dummyUserImage,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          TalkBase().userServices.curentUser.nickName,
          textAlign: TextAlign.center,
          style: midiumTextStyle(),
        ),
      ],
    );
  }
}
