import 'package:flutter/material.dart';
import 'package:talk/models/chat.dart';
import 'package:talk/pages/chat_screen.dart';
import 'package:talk/services/talk_base.dart';
import 'package:talk/utils/helpers.dart';
import 'package:talk/utils/service_constats.dart';
import 'package:talk/utils/style_helpers.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<Chat> allChats = [];

  @override
  void initState() {
    getAllChats();
    if (mounted) {
      (TalkBase().chatServices.userChatsStream().data as Stream)
          .listen((event) {
        if (mounted) {
          getAllChats();
        }
      });
    }
    super.initState();
  }

  void getAllChats() async {
    var res = await TalkBase().chatServices.userAllChats();
    if (res.data.length > 0) {
      if (mounted) {
        setState(() {
          allChats = res.data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: formScaffoldPadding,
        height: MediaQuery.of(context).size.height * 0.5,
        child: ListView.separated(
          separatorBuilder: (c, i) => Divider(
            thickness: 2,
          ),
          itemBuilder: (c, i) => ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => ChatScreen(
                    chat: allChats[i],
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(
                allChats[i]
                        .users
                        .firstWhere((element) =>
                            element.id != TalkBase().userServices.curentUser.id)
                        .imageLink ??
                    dummyUserImage,
              ),
            ),
            title: Text(
              allChats[i]
                  .users
                  .firstWhere((element) =>
                      element.id != TalkBase().userServices.curentUser.id)
                  .nickName,
              style: largeTextStyle(),
            ),
            subtitle: StreamBuilder(
              builder: (c, s) {
                switch (s.connectionState) {
                  case ConnectionState.active:
                    return s.data.data() != null
                        ? Text(
                            s.data.data()[lastMessage]["text"] ?? "not exist",
                            style: midiumTextStyle(),
                          )
                        : Text(
                            "chat is empty",
                            style: midiumTextStyle(),
                          );

                    break;
                  default:
                }
                return Text("null");
              },
              stream: TalkBase()
                  .chatServices
                  .lastMessageStream(chatId: allChats[i].chatId)
                  .data,
            ),
            trailing: Icon(
              Icons.messenger_outline_sharp,
            ),
          ),
          itemCount: allChats.length,
        ),
      ),
    );
  }
}
