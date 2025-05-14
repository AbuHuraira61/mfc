import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mfc/Constants/colors.dart';

class FirestoreChatService{
final FirebaseAuth _auth = FirebaseAuth.instance;
  late final CollectionReference _messagesRef;

  FirestoreChatService() {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    _messagesRef = FirebaseFirestore.instance
        .collection('chatbot')
        .doc(user.uid)
        .collection('messages');
  }

  Stream<QuerySnapshot> getMessagesStream() {
    return _messagesRef.orderBy('timestamp').snapshots();
  }

  Future<void> sendMessage( {required String text,required bool isUser}) async {
    await _messagesRef.add({
      'text': text,
      'isUser': isUser,
      'timestamp': Timestamp.now(),
    });
  }

 Future<void> clearMessages() async {
  final user = _auth.currentUser;
  if (user != null) {
    try {

      final snapshot = await _messagesRef.get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      Get.snackbar('Clear!', 'Your chat is cleared now!');
    } catch (e) {
      Get.snackbar(
        'Error!',
        'Unexpected error occurred: $e',
        backgroundColor: primaryColor,
      );
    }
  }
}




}