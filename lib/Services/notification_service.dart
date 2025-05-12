import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService {
  
  FirebaseMessaging messaging = FirebaseMessaging.instance;





 void firebaseNotificationInit(){
   FirebaseMessaging.onMessage.listen((message) {
     
   },);
 }
 


  requestNotificarionPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: true,
      announcement: true,
      criticalAlert: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }
  

 void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  


}