import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initialize() async {
    try {
      // Request permission for notifications
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        debugPrint('Notification permissions not granted');
        return;
      }

      // Initialize local notifications for Android
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification tapped: ${response.payload}');
          // Here you can handle notification tap
        },
      );

      // Create notification channel for Android with enhanced settings
      await _createNotificationChannel();

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');
        _showNotification(message);
      });

      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('Message clicked!');
        debugPrint('Message data: ${message.data}');
        // Handle notification tap here
      });

      // Get and update FCM token
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        await _updateUserToken(token);
      }

      // Handle token refresh
      _firebaseMessaging.onTokenRefresh.listen((String token) async {
        debugPrint('FCM Token Refreshed: $token');
        await _updateUserToken(token);
      });

    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
      enableLights: true,
      ledColor: Color(0xFF570101),
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _updateUserToken(String token) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'deviceToken': token,
          'lastTokenUpdate': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating user token: $e');
    }
  }

  Future<String> getDeviceToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token == null) {
        throw Exception('Failed to get device token');
      }
      await _updateUserToken(token);
      return token;
    } catch (e) {
      print('Error getting device token: $e');
      rethrow;
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    try {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        await _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription: 'This channel is used for important notifications.',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
              color: const Color(0xff570101),
              playSound: true,
              enableVibration: true,
              showWhen: true,
              enableLights: true,
              ticker: 'New notification',
              fullScreenIntent: true,
            ),
          ),
          payload: message.data['orderId'],
        );
      }
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  // Notification sending methods
  Future<void> sendNewOrderNotification(String orderId) async {
    try {
      // Get admin's token
      final adminDoc = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();
      
      if (adminDoc.docs.isEmpty) return;
      
      final adminToken = adminDoc.docs.first['deviceToken'] as String?;
      if (adminToken == null) return;

      // Create notification document
      await _firestore.collection('notifications').add({
        'token': adminToken,
        'title': 'New Order',
        'body': 'You have received a new order #$orderId',
        'orderId': orderId,
        'timestamp': FieldValue.serverTimestamp(),
        'priority': 'high',
      });
    } catch (e) {
      print('Error sending new order notification: $e');
    }
  }

  Future<void> sendOrderAcceptedNotification(String customerToken, String orderId) async {
    try {
      await _firestore.collection('notifications').add({
        'token': customerToken,
        'title': 'Order Accepted',
        'body': 'Your order #$orderId has been accepted and is being prepared',
        'orderId': orderId,
        'timestamp': FieldValue.serverTimestamp(),
        'priority': 'high',
      });
    } catch (e) {
      print('Error sending order accepted notification: $e');
    }
  }

  Future<void> sendOrderAssignedNotification(String riderToken, String orderId) async {
    try {
      await _firestore.collection('notifications').add({
        'token': riderToken,
        'title': 'New Order Assignment',
        'body': 'You have been assigned order #$orderId',
        'orderId': orderId,
        'timestamp': FieldValue.serverTimestamp(),
        'priority': 'high',
      });
    } catch (e) {
      print('Error sending order assigned notification: $e');
    }
  }

  Future<void> sendOrderOnTheWayNotification(
      String customerToken, String adminToken, String orderId) async {
    try {
      // Send to customer
      await _firestore.collection('notifications').add({
        'token': customerToken,
        'title': 'Order On The Way',
        'body': 'Your order #$orderId is on the way',
        'orderId': orderId,
        'timestamp': FieldValue.serverTimestamp(),
        'priority': 'high',
      });

      // Send to admin
      await _firestore.collection('notifications').add({
        'token': adminToken,
        'title': 'Order Dispatched',
        'body': 'Order #$orderId has been dispatched',
        'orderId': orderId,
        'timestamp': FieldValue.serverTimestamp(),
        'priority': 'high',
      });
    } catch (e) {
      print('Error sending order on the way notification: $e');
    }
  }

  Future<void> sendOrderCompletedNotification(
      String customerToken, String adminToken, String orderId) async {
    try {
      // Send to customer
      await _firestore.collection('notifications').add({
        'token': customerToken,
        'title': 'Order Completed',
        'body': 'Your order #$orderId has been delivered',
        'orderId': orderId,
        'timestamp': FieldValue.serverTimestamp(),
        'priority': 'high',
      });

      // Send to admin
      await _firestore.collection('notifications').add({
        'token': adminToken,
        'title': 'Order Completed',
        'body': 'Order #$orderId has been completed',
        'orderId': orderId,
        'timestamp': FieldValue.serverTimestamp(),
        'priority': 'high',
      });
    } catch (e) {
      print('Error sending order completed notification: $e');
    }
  }
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  
  // Initialize Firebase if needed
  await Firebase.initializeApp();
  
  // Show notification even in background
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xff570101),
          playSound: true,
          enableVibration: true,
          showWhen: true,
        ),
      ),
      payload: message.data['orderId'],
    );
  }
}