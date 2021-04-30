import 'package:flutter/material.dart';
import 'package:talk/models/chat.dart';
import 'package:talk/models/message.dart';
import 'package:talk/services/talk_base.dart';
import 'package:talk/utils/enums.dart';
import 'package:talk/utils/style_helpers.dart';
import 'package:talk/widgets/inputs.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  ChatScreen({this.chat});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final curentUserId = TalkBase().userServices.curentUser.id;
  String receiverId;

  final ScrollController chatScrollController = ScrollController();

  @override
  void initState() {
    receiverId = widget.chat.users
        .firstWhere((element) => element.id != curentUserId)
        .id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      padding: EdgeInsets.all(3),
                      child: Text(
                        "Chat with ${widget.chat.users.firstWhere((element) => element.id != TalkBase().userServices.curentUser.id).nickName}",
                        textAlign: TextAlign.center,
                        style: largeTextStyle(),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: TalkBase()
                      .chatServices
                      .chatMessagesStream(chatId: widget.chat.chatId)
                      .data,
                  builder: (c, s) {
                    switch (s.connectionState) {
                      case ConnectionState.active:
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 5,
                          ),
                          child: ListView.separated(
                            controller: chatScrollController,
                            separatorBuilder: (c, i) => SizedBox(
                              height: 5,
                            ),
                            itemBuilder: (c, i) {
                              Message message =
                                  Message.fromJson(s.data.docs[i]);
                              return Container(
                                alignment: message.senderId == curentUserId
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.blue, Colors.purple],
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25),
                                        bottomLeft:
                                            message.senderId != curentUserId
                                                ? Radius.zero
                                                : Radius.circular(10),
                                        bottomRight:
                                            message.senderId == curentUserId
                                                ? Radius.zero
                                                : Radius.circular(10),
                                      )),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    message.text,
                                    style: midiumTextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                            itemCount: s.data.docs.length,
                          ),
                        );
                        break;
                      default:
                        Text("loading");
                    }
                    return Text("someting is wrong");
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  children: [
                    Expanded(
                        child: CustomFormInput(
                      controller: _messageController,
                      hint: "message",
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 30,
                      ),
                      onPressed: () async {
                        await TalkBase().chatServices.sendMessage(
                              chatId: widget.chat.chatId,
                              message: Message(
                                dateTime: DateTime.now(),
                                state: MessageState.Sended,
                                text: _messageController.text,
                                receiverId: receiverId,
                                senderId: curentUserId,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
