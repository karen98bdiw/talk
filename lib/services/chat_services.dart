import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talk/models/chat.dart';
import 'package:talk/models/message.dart';
import 'package:talk/models/service_response.dart';
import 'package:talk/models/user.dart';
import 'package:talk/services/talk_base.dart';
import 'package:talk/utils/service_constats.dart';

class ChatServices {
  final FirebaseFirestore store;

  ChatServices({this.store});

  Future<ServiceResponse> getChatById({String chatId}) async {
    try {
      var res = await store.collection(chatsCollection).doc(chatId).get();
      if (res.exists) {
        return ServiceResponse(
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

  ServiceResponse userChatsStream({String userId}) {
    return ServiceResponse(
      done: true,
      data: store
          .collection(usersCollection)
          .doc(TalkBase().userServices.curentUser.id)
          .collection(userChats)
          .snapshots(),
    );
  }

  Future<ServiceResponse> userAllChats({String userId}) async {
    List<Chat> chats = [];
    var userChatsRef = await store
        .collection(usersCollection)
        .doc(TalkBase().userServices.curentUser.id)
        .collection(userChats)
        .get();

    for (int i = 0; i < userChatsRef.docs.length; i++) {
      var chatResponse =
          await getChatById(chatId: userChatsRef.docs[i]["chatId"]);
      if (chatResponse.errorText == null) {
        chats.add(chatResponse.data);
      }
      print(chats);
    }
    return ServiceResponse(done: true, data: chats);
  }

  ServiceResponse chatMessagesStream({String chatId}) {
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
          .doc(message.dateTime.toString())
          .set(message.toJson());
      await store
          .collection(chatsCollection)
          .doc(chatId)
          .collection(lastMessage)
          .doc("0")
          .set({lastMessage: message.toJson()});
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

  ServiceResponse lastMessageStream({String chatId}) {
    return ServiceResponse(
      done: true,
      data: store
          .collection(chatsCollection)
          .doc(chatId)
          .collection(lastMessage)
          .doc("0")
          .snapshots(),
    );
  }

  Future<ServiceResponse> createChat({List<User> chatUsers}) async {
    try {
      var chatExist =
          await isChatExist(firstUser: chatUsers[0], secondUser: chatUsers[1]);
      print("chatExist :${chatExist.data}");

      if (!chatExist.data) {
        var newChatId = chatUsers.map((e) => e.id).toList().join("+");
        var newChat = Chat(chatId: newChatId, users: chatUsers);

        await store.collection(chatsCollection).doc(newChatId).set(
              newChat.toJson(),
            );
        await store
            .collection(usersCollection)
            .doc(chatUsers[0].id)
            .collection(userChats)
            .add({"chatId": newChatId});
        await store
            .collection(usersCollection)
            .doc(chatUsers[1].id)
            .collection(userChats)
            .add({"chatId": newChatId});
        return ServiceResponse(data: newChat, done: true);
      } else {
        return ServiceResponse(data: chatAlreadyExist, done: true);
      }
    } catch (e) {
      return ServiceResponse(done: false, errorText: e.toString());
    }
  }

  Future<ServiceResponse> isChatExist({User firstUser, User secondUser}) async {
    try {
      var chatIdVariantOne = firstUser.id + "+" + secondUser.id;
      var chatIdVariantTwo = secondUser.id + "+" + firstUser.id;

      var chatExistWithVariantOne =
          await store.collection(chatsCollection).doc(chatIdVariantOne).get();
      var chatExistWithVariantTwo =
          await store.collection(chatsCollection).doc(chatIdVariantTwo).get();
      if (chatExistWithVariantTwo.exists || chatExistWithVariantOne.exists) {
        return ServiceResponse(data: true, done: true);
      }
      return ServiceResponse(data: false, done: true);
    } catch (e) {
      return ServiceResponse(done: false, errorText: e.toString());
    }
  }
}
