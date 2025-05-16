import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:mfc/Chatbot/ChatbotScreeen.dart';

class FcmService {

  static void firebaseinit(){
   FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
     
   },);

  
  }
 
}