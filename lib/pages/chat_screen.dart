import 'package:flutter/material.dart';
import 'package:talk/models/chat.dart';
import 'package:talk/models/message.dart';
import 'package:talk/services/talk_base.dart';
import 'package:talk/utils/enums.dart';

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

  @override
  void initState() {
    receiverId = widget.chat.users
        .firstWhere((element) => element.id != curentUserId)
        .id;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: StreamBuilder(
                stream: TalkBase()
                    .chatServices
                    .chatMessagesStream(chatId: widget.chat.chatId)
                    .data,
                builder: (c, s) {
                  switch (s.connectionState) {
                    case ConnectionState.active:
                      return ListView.builder(
                        itemBuilder: (c, i) {
                          Message message = Message.fromJson(s.data.docs[i]);
                          return Container(
                            alignment: message.senderId == curentUserId
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(message.text),
                            ),
                          );
                        },
                        itemCount: s.data.docs.length,
                      );
                      break;
                    default:
                      Text("loading");
                  }
                  return Text("someting is wrong");
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "message",
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    var res = await TalkBase().chatServices.sendMessage(
                          chatId: widget.chat.chatId,
                          message: Message(
                            dateTime: DateTime.now(),
                            state: MessageState.Sended,
                            text: _messageController.text,
                            receiverId: receiverId,
                            senderId: curentUserId,
                          ),
                        );
                    print(res.done);
                    print(res.errorText);
                    print(res.data);
                  },
                ),
              ],
            )
          ],
        ));
  }
}
