import 'package:flutter/material.dart';
import 'package:talk/models/chat.dart';
import 'package:talk/models/user.dart';
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
  List<User> allUsers = [];

  void getAllUsers() async {
    var res = await TalkBase().userServices.getAllUsers();

    if (res.data.length > 0) {
      setState(() {
        allUsers = res.data;
      });
    } else {
      print("users not fined");
    }
  }

  @override
  void initState() {
    getAllChats();
    getAllUsers();
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
      body: SafeArea(
        child: Container(
          padding: formScaffoldPadding,
          child: Column(
            children: [
              appBar(),
              SizedBox(height: 12),
              searchInput(),
              SizedBox(height: 14),
              usersList(),
              Expanded(
                child: chatsView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget usersList() => Container(
        padding: EdgeInsets.only(top: 15),
        height: 106,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: curentUserView()),
            SizedBox(
              width: 28,
            ),
            Expanded(
              child: Container(
                height: 106,
                child: ListView.separated(
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, i) => userItemView(
                    user: allUsers[i],
                  ),
                  separatorBuilder: (c, i) => SizedBox(
                    width: 28,
                  ),
                  itemCount: allUsers.length,
                ),
              ),
            ),
          ],
        ),
      );

  Widget curentUserView() => Container(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              TalkBase().userServices.curentUser.nickName,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.35),
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );

  Widget userItemView({User user}) => Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(
                    user.imageLink ?? dummyUserImage,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              user.nickName,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.35),
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );

  Widget searchInput() => TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            isDense: true,
            filled: true,
            fillColor: Color.fromRGBO(0, 0, 0, 0.05),
            hintText: "Search",
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.only(),
              child: Icon(
                Icons.search,
              ),
            )),
      );

  Widget appBar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(
                  TalkBase().userServices.curentUser.imageLink ??
                      dummyUserImage,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                "Chats",
                style: largeTextStyle(),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.article_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      );

  Widget chatsView() => ListView.separated(
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
      );
}
