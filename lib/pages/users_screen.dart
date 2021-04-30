import 'package:flutter/material.dart';
import 'package:talk/models/user.dart';
import 'package:talk/pages/chat_screen.dart';
import 'package:talk/services/talk_base.dart';
import 'package:talk/utils/helpers.dart';
import 'package:talk/utils/service_constats.dart';
import 'package:talk/utils/style_helpers.dart';
import 'package:talk/widgets/helperWidgets.dart';

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                curentUserInfo(),
                SizedBox(
                  height: 20,
                ),
                allUser.length > 0
                    ? allUserInfo()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      ),
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
              var res = await TalkBase().chatServices.createChat(
                chatUsers: [allUser[i], TalkBase().userServices.curentUser],
              );
              if (res.done) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (c) => ChatScreen(
                            chat: res.data,
                          )),
                );
              }
            },
            trailing: StreamBuilder(
              builder: (c, s) {
                switch (s.connectionState) {
                  case ConnectionState.active:
                    return s.data.data() != null
                        ? CircleAvatar(
                            radius: 5,
                            backgroundColor: s.data.data()[isOnline]
                                ? Colors.green
                                : Colors.orange,
                          )
                        : CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.red,
                          );

                    break;
                  default:
                    Text("loading...");
                    break;
                }
                return Text("loading...");
              },
              stream: TalkBase()
                  .userServices
                  .userStateStream(userId: allUser[i].id)
                  .data,
            ),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  NetworkImage(allUser[i].imageLink ?? dummyUserImage),
            ),
            title: Text(
              allUser[i].nickName,
              style: largeTextStyle(),
            ),
            subtitle: Text(
              allUser[i].email,
              style: midiumTextStyle(),
            ),
          ),
          itemCount: allUser.length,
        ),
      );

  Widget curentUserInfo() {
    print(TalkBase().userServices.curentUser.toJson());
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 110,
          width: 110,
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(
                TalkBase().userServices.curentUser.imageLink ?? dummyUserImage),
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
