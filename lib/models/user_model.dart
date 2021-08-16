import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
FirebaseAuth _auth = FirebaseAuth.instance;

class UserModel {
  static String currentUserEmail = (_auth.currentUser?.email).toString();
  static User? currentUser = _auth.currentUser;

  static Future<Map> getCurrentUserData() async {
    var user = await usersCollection.where('email', isEqualTo: _auth.currentUser?.email).get();
    final userData = user.docs.first.data() as Map;
    return {
      'user_id': user.docs.first.id,
      ...userData,
    };
  }

  static Future<Map> getUserById(String userId) async {
    var user = await usersCollection.doc(userId).get();
    final userData = user.data() as Map;
    return {
      'user_id': userId,
      ...userData,
    };
  }

  static Future<Map> getUserByEmail(String email) async {
    var user = await usersCollection.where('email', isEqualTo: email).get();
    final userData = user.docs.first.data() as Map;
    return {
      'user_id': user.docs.first.id,
      ...userData,
    };
  }

  static Future<Map> getUserByPhone(String phone) async {
    var user = await usersCollection.where('phone', isEqualTo: phone).get();
    if (user.docs.length > 0) {
      final userData = user.docs.first.data() as Map;
      return {
        'user_id': user.docs.first.id,
        ...userData,
      };
    } else
      return {};
  }

  static Future<bool> isUserPhoneExist(String phone) async {
    final users = await usersCollection.where('phone', isEqualTo: phone).get();
    return users.docs.length > 0 ? true : false;
  }

  static void addUser(Map<String, dynamic> user) async {
    await usersCollection
        .add(user)
        .then((value) => print('User added'))
        .catchError((error) => print('Failed to add the User: $error'));
  }

  static void signOut() async {
    await _auth.signOut();
  }
}
