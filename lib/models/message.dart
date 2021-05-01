import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talk/utils/enums.dart';
import 'package:talk/utils/helpers.dart';

class Message {
  String senderId;
  String receiverId;
  String text;
  MessageState state;
  DateTime dateTime;
  bool isLink;

  Message(
      {this.receiverId,
      this.senderId,
      this.text,
      this.state,
      this.dateTime,
      this.isLink = false});

  factory Message.fromJson(json) {
    return Message(
      receiverId: json["receiverId"],
      senderId: json["senderId"],
      text: json["text"],
      state: messageStateFromString(json["state"]),
      dateTime: (json["dateTime"] as Timestamp).toDate(),
      isLink: json["isLink"],
    );
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data["dateTime"] = DateTime.now();
    data["receiverId"] = this.receiverId;
    data["senderId"] = this.senderId;
    data["text"] = this.text;
    data["state"] = messageStateToString(this.state);
    data["isLink"] = this.isLink;
    return data;
  }
}
