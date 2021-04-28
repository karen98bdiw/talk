import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talk/models/chat.dart';
import 'package:talk/models/message.dart';
import 'package:talk/models/service_response.dart';
import 'package:talk/utils/service_constats.dart';

class ChatServices {
  final FirebaseFirestore store;

  ChatServices({this.store});

  Future<ServiceResponse> getChatById({String chatId}) async {
    try {
      var res = await store.collection(chatsCollection).doc(chatId).get();
      if (res.exists) {
        ServiceResponse(
          data: Chat.fromJson(res.data()),
          done: true,
        );
      }
      return ServiceResponse(
        done: false,
        errorText: chatNotExist,
      );
    } catch (e) {
      return ServiceResponse(
        done: false,
        errorText: e.toString(),
      );
    }
  }

  Future<ServiceResponse> chatMessagesStream({String chatId}) async {
    try {
      var messagesStream = store
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .snapshots();
      if (messagesStream.isBroadcast) {
        return ServiceResponse(
          data: messagesStream,
          done: true,
        );
      }
      return ServiceResponse(
        errorText: messagesIsNotBrodcasting,
        done: false,
      );
    } catch (e) {
      return ServiceResponse(
        errorText: messagesIsNotBrodcasting,
        done: false,
      );
    }
  }

  Future<ServiceResponse> sendMessage({Message message, String chatId}) async {
    try {
      await store
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .add(message.toJson());
      await store
          .collection(chatsCollection)
          .doc(chatId)
          .update({"lastMessage": message.toJson()});
      return ServiceResponse(
        done: true,
      );
    } catch (e) {
      return ServiceResponse(
        done: false,
        errorText: e.toString(),
      );
    }
  }
}
