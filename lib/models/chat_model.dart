import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_test/models/message_model.dart';

CollectionReference chatsCollection = FirebaseFirestore.instance.collection('chats');

class ChatModel {
  late String chatId;
  late String firstUserId;
  late String secondUserId;
  late int createdAt;
  late int updatedAt;

  static Future<List<ChatModel>> getAllUserChats(String currentUserId) async {
    List<ChatModel> chats = [];
    chats.addAll(await getChats('first_user_id', currentUserId)); //created chats
    chats.addAll(await getChats('second_user_id', currentUserId)); //added chats
    // sort List<Objects>
    if (chats.isNotEmpty) {
      chats.sort((chat1, chat2) {
        return (chat2.updatedAt).compareTo(chat1.updatedAt);
      });
    }
    return chats;
  }

  static Future<List<ChatModel>> getChats(String userId, String currentUserId) async {
    List<ChatModel> chatsObjects = [];
    await chatsCollection
        .orderBy('updated_at', descending: true)
        .where(userId, isEqualTo: currentUserId)
        .get()
        .then((createdChats) {
      createdChats.docs.forEach((chat) {
        final chatData = chat.data() as Map;
        ChatModel chatObject = ChatModel();
        chatObject.chatId = chat.id;
        chatObject.firstUserId = chatData['first_user_id'];
        chatObject.secondUserId = chatData['second_user_id'];
        chatObject.createdAt = chatData['created_at'];
        chatObject.updatedAt = chatData['updated_at'];
        chatsObjects.add(chatObject);
      });
    });
    return chatsObjects;
  }

  // static Future<int> getLastChatId() async {
  //   final chats = await chatsCollection.orderBy('created_at').get();
  //   final lastUserId = chats.docs.length > 0 ? (chats.docs.last.data() as Map)['chat_id'] : 0;
  //   return lastUserId;
  // }

  static Future<Map> getChatById(String chatId) async {
    var chat = await chatsCollection.doc(chatId).get();
    final chatData = chat.data() as Map;
    return {
      'chat_id': chatId,
      ...chatData,
    };
  }

  static Future<bool> isChatExist({required String currentUserId, required String otherUserId}) async {
    final chats = await chatsCollection
        .where('first_user_id', isEqualTo: currentUserId)
        .where('second_user_id', isEqualTo: otherUserId)
        .get();
    if (chats.docs.length > 0)
      return true;
    else {
      final chats = await chatsCollection
          .where('first_user_id', isEqualTo: otherUserId)
          .where('second_user_id', isEqualTo: currentUserId)
          .get();
      return chats.docs.length > 0 ? true : false;
    }
  }

  void create() async {
    await chatsCollection.add({
      'first_user_id': this.firstUserId,
      'second_user_id': this.secondUserId,
      'created_at': this.createdAt,
      'updated_at': this.updatedAt,
    }).then((value) => print('chat created successfully.'));
  }

  static void updateChat({required String chatId, required int updatedAt}) async {
    await chatsCollection
        .doc(chatId)
        .update({'updated_at': updatedAt}).then((value) => print('chat updated successfully.'));
  }

  static void deleteChat(chatId) async {
    MessageModel.deleteAllChatMessages(chatId);
    await chatsCollection.doc(chatId).delete().then((value) => print('Chat deleted successfully.'));
  }
}
