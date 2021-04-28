import 'package:talk/models/message.dart';
import 'package:talk/models/user.dart';

class Chat {
  String chatId;
  List<User> users = [];
  List<Message> messages = [];
  Message lastMessage;

  Chat({this.messages, this.users, this.chatId, this.lastMessage});

  factory Chat.fromJson(json) {
    var chat = Chat(
      chatId: json["chatId"],
      lastMessage: json["lastMessage"],
      messages: json["messages"] != null
          ? (json["messages"] as List).map((e) => Message.fromJson(e)).toList()
          : [],
      users: json["users"] != null
          ? (json["users"] as List).map((e) => User.fromJson(e)).toList()
          : [],
    );
    chat.messages
        .sort((a, b) => a.dateTime.toString().compareTo(b.dateTime.toString()));
    return chat;
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data["chatId"] = this.chatId;
    data["lastMessage"] = this.lastMessage;
    data["messages"] = this.messages.map((e) => e.toJson()).toList();
    data["users"] = this.users.map((e) => e.toJson()).toList();
    return data;
  }
}
