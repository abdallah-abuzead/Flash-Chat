import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_test/models/chat_model.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
CollectionReference messagesCollection = _firestore.collection('messages');

class MessageModel {
  // static Future<int> getLastMessageId() async {
  //   final messages = await messagesCollection.orderBy('created_at').get();
  //   int lastMessageId = messages.docs.length > 0 ? (messages.docs.last.data() as Map)['message_id'] : 0;
  //   return lastMessageId;
  // }

  static void addMessage(Map<String, dynamic> message) async {
    await messagesCollection.add(message).then((value) => print('Message added'));
    ChatModel.updateChat(chatId: message['chat_id'], updatedAt: message['created_at']);
  }

  static Future<String> getLastChatMessage({required String chatId, required int chatUpdatedAt}) async {
    String message = '';
    final messages = await messagesCollection
        .where('created_at', isEqualTo: chatUpdatedAt)
        .where('chat_id', isEqualTo: chatId)
        .get();
    if (messages.docs.length > 0) message = (messages.docs.first.data() as Map)['text'];
    // if (message.length > 35) message = message.substring(0, 35) + ' ... ';
    return message;
  }

  static Stream<QuerySnapshot> getChatMessages(String chatId) {
    final chatMessages =
        messagesCollection.where('chat_id', isEqualTo: chatId).orderBy('created_at').snapshots();
    return chatMessages;
  }

  static void deleteAllChatMessages(String chatId) async {
    await messagesCollection.where('chat_id', isEqualTo: chatId).get().then((messages) {
      messages.docs.forEach((message) {
        message.reference.delete();
      });
    });
  }

  static void deleteMessage(docId) {
    messagesCollection.doc(docId).delete().then((value) => print('Message deleted successfully.'));
  }
}
