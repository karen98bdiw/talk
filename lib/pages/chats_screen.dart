import 'package:flutter/material.dart';
import 'package:talk/models/chat.dart';
import 'package:talk/pages/chat_screen.dart';
import 'package:talk/services/talk_base.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<Chat> allChats = [];

  @override
  void initState() {
    getAllChats();
    super.initState();
  }

  void getAllChats() async {
    var res = await TalkBase().chatServices.userAllChats();
    if (res.data.length > 0) {
      setState(() {
        allChats = res.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: ListView.builder(
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
            title: Text(allChats[i]
                .users
                .firstWhere((element) =>
                    element.id != TalkBase().userServices.curentUser.id)
                .nickName),
            subtitle: Text(allChats[i].lastMessage?.text ?? ""),
          ),
          itemCount: allChats.length,
        ),
      ),
    );
  }
}
