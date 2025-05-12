// import 'package:get/get.dart';
// import '../services/notification_service.dart';

// class NotificationController extends GetxController {
//   final NotificationService _notificationService = NotificationService();

//   @override
//   void onInit() {
//     super.onInit();
//     _notificationService.initialize();
//   }

//   void showCartUpdateNotification() {
//     _notificationService.showNotification(
//       id: 0,
//       title: 'Cart Updated',
//       body: 'A new item has been added to your cart.',
//       payload: 'cart_updated',
//     );
//   }

//   void scheduleReminderNotification(DateTime reminderTime) {
//     _notificationService.scheduleNotification(
//       id: 1,
//       title: 'Task Reminder',
//       body: 'Your task is due soon!',
//       scheduledTime: reminderTime,
//       payload: 'task_reminder',
//     );
//   }
// }