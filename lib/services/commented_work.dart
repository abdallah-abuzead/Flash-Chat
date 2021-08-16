// import 'package:flutter/material.dart';

// List<MessageContainer> messagesList = [];
// void getMessagesOneTimeRead() async {
//   CollectionReference messagesCollection = _firestore.collection('messages');
//   var messages = await messagesCollection.get();
//   List<MessageContainer> messagesContainers = [];
//   messages.docs.forEach((message) {
//     Map<String, dynamic> data = message.data() as Map<String, dynamic>;
//     messagesContainers.add(MessageContainer(data: data));
//     print('(${message.id}) ' + data['text']);
//   });
//   setState(() {
//     messagesList = messagesContainers;
//   });
// }

// void getMessagesRealTimeChanges() async {
//   Stream<QuerySnapshot> messagesSnapshots = _firestore.collection('messages').snapshots();
//   await for (var snapshot in messagesSnapshots) {
//     for (var message in snapshot.docs) {
//       Map<String, dynamic> data = message.data() as Map<String, dynamic>;
//       print(data['text'] + '  ----  stream');
//     }
//   }
// }

// int lastMessageId = 0;
// void getLastMessageId() async {
//   CollectionReference messagesCollection = _firestore.collection('messages');
//   var messages = await messagesCollection.orderBy('created_at').get();
//   lastMessageId = int.parse(messages.docs.last.id);
// }

// FutureBuilder<DocumentSnapshot> getMessageById() {
//   CollectionReference messages = _firestore.collection('messages');
//   return FutureBuilder<DocumentSnapshot>(
//     future: messages.doc('10').get(),
//     builder: (context, snapshot) {
//       if (snapshot.hasError) return Text('something went wrong!');
//       if (snapshot.hasData && !snapshot.data!.exists) return Text('Document does not exist');
//       if (snapshot.connectionState == ConnectionState.done) {
//         Map<String, dynamic> data = snapshot.data?.data() as Map<String, dynamic>;
//         return Text(data['text']);
//       }
//       return Text('Loading');
//     },
//   );
// }
