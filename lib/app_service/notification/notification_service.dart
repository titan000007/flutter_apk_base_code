// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:uber_boats_customer/app/features/chat/view/chat_screen.dart';
// import '../../main.dart';
// import '../../utils/app_log.dart';
// import '../../utils/app_utils.dart';
// import '../../utils/shared_preferences.dart';
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//
//   factory NotificationService() => _instance;
//
//   NotificationService._internal();
//
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//   FlutterLocalNotificationsPlugin();
//
//   static const AndroidNotificationChannel _androidChannel =
//   AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'Used for important notifications.',
//     importance: Importance.high,
//   );
//
//   Future<void> init() async {
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       AppLog.printLog('User granted permission');
//     } else {
//       AppLog.printLog('User declined or has not accepted permission');
//     }
//
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosInit = DarwinInitializationSettings();
//     const initSettings = InitializationSettings(
//       android: androidInit,
//       iOS: iosInit,
//     );
//
//     await _localNotifications.initialize(
//       settings: initSettings,
//       onDidReceiveNotificationResponse: (response) {
//         if (response.payload != null) {
//           final payload = jsonDecode(response.payload!);
//           _handleMessageNavigationFromMap(payload);
//         }
//       },
//     );
//
//     await _messaging.setForegroundNotificationPresentationOptions(
//       alert: false,
//       badge: true,
//       sound: true,
//     );
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(message);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleMessageNavigationFromMap(message.data);
//     });
//
//     RemoteMessage? initialMsg = await _messaging.getInitialMessage();
//     if (initialMsg != null) {
//       Future.delayed(const Duration(seconds: 3), () {
//         _handleMessageNavigationFromMap(initialMsg.data);
//       });
//     }
//
//     // Customer ka token 'users' collection mein save karo
//     final token = await FirebaseMessaging.instance.getToken();
//     final userId = sp?.getString(SpUtil.userID) ?? '';
//
//     AppLog.printLog('FCM Token: $token');
//     AppLog.printLog('userId: $userId');
//
//     if (token != null && token.isNotEmpty) {
//       sp!.putString(SpUtil.deviceFcmToken, token);
//
//       if (userId.isNotEmpty) {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .set({'fcmToken': token}, SetOptions(merge: true));
//         AppLog.printLog(' FCM token saved to users for: $userId');
//       }
//     }
//
//     // Token refresh — 'users' collection
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       sp!.putString(SpUtil.deviceFcmToken, newToken);
//       final uid = sp?.getString(SpUtil.userID) ?? '';
//       if (uid.isNotEmpty) {
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(uid)
//             .set({'fcmToken': newToken}, SetOptions(merge: true));
//       }
//     });
//   }
//
//   Future<void> _showNotification(RemoteMessage message) async {
//     final notification = message.notification;
//     if (notification == null) return;
//
//     final androidDetails = AndroidNotificationDetails(
//       _androidChannel.id,
//       _androidChannel.name,
//       channelDescription: _androidChannel.description,
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//     );
//
//     const iosDetails = DarwinNotificationDetails();
//
//     final details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _localNotifications.show(
//       id: notification.hashCode,
//       title: notification.title,
//       body: notification.body,
//       notificationDetails: details,
//       payload: jsonEncode(message.data),
//     );
//   }
//
//   void _handleMessageNavigationFromMap(Map<String, dynamic> data) {
//     AppLog.printLog("RemoteMessage Data ===> ${data.toString()}");
//
//     String? type = data['type']?.toString();
//     String? senderId = data['senderId']?.toString();
//     String? senderName = data['senderName']?.toString();
//     String? senderImage = data['senderImage']?.toString();
//     String? senderRole = data['senderRole']?.toString();
//     String? orderId = data['orderId']?.toString();
//
//     AppLog.printLog("type ===> $type");
//     AppLog.printLog("senderId ===> $senderId");
//     AppLog.printLog("senderName ===> $senderName");
//     AppLog.printLog("senderRole ===> $senderRole");
//     AppLog.printLog("orderId ===> $orderId");
//
//     if (AppUtils.checkUserLogin()) {
//       //  'chat_message' aur 'new_message' dono handle karo
//       if (type == 'chat_message' || type == 'new_message') {
//         Get.to(
//           ChatScreen(),
//           arguments: {
//             'otherUserId': senderId,
//             'otherUserName': senderName,
//             'otherUserImage': senderImage,
//             'otherUserRole': senderRole,
//             'orderId': orderId,
//           },
//         );
//       }
//     }
//   }
// }

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/features/chat/controllers/chat_controller.dart';
import 'package:uber_boats_customer/app/features/chat/view/chat_screen.dart';
import '../../main.dart';
import '../../utils/app_log.dart';
import '../../utils/app_utils.dart';
import '../../utils/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications.',
    importance: Importance.high,
  );

  Future<void> init() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      AppLog.printLog('User granted permission');
    } else {
      AppLog.printLog('User declined or has not accepted permission');
    }

    const androidInit = AndroidInitializationSettings('ic_notification');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      settings:initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final payload = jsonDecode(response.payload!);
          _handleMessageNavigationFromMap(payload);
        }
      },
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageNavigationFromMap(message.data);
    });

    RemoteMessage? initialMsg = await _messaging.getInitialMessage();
    if (initialMsg != null) {
      Future.delayed(const Duration(seconds: 3), () {
        _handleMessageNavigationFromMap(initialMsg.data);
      });
    }

    final token = await FirebaseMessaging.instance.getToken();
    final userId = sp?.getString(SpUtil.userID) ?? '';

    AppLog.printLog('FCM Token: $token');
    AppLog.printLog('userId: $userId');

    if (token != null && token.isNotEmpty) {
      sp!.putString(SpUtil.deviceFcmToken, token);
      if (userId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(userId)
            .set({
          'fcmToken': token,
          'role': 'customer',
        }, SetOptions(merge: true));
        AppLog.printLog('FCM token saved to users for customer: $userId');
      }
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      sp!.putString(SpUtil.deviceFcmToken, newToken);
      final uid = sp?.getString(SpUtil.userID) ?? '';
      if (uid.isNotEmpty) {
        FirebaseFirestore.instance.collection('chat_rooms').doc(uid).set({
          'fcmToken': newToken,
          'role': 'customer',
        }, SetOptions(merge: true));
      }
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    // Suppress notification if user is already in the same chat room
    if (message.data['type'] == 'chat_message' ||
        message.data['type'] == 'new_message') {
      final incomingRoomId = message.data['roomId']?.toString();
      if (Get.isRegistered<ChatController>()) {
        final chatController = Get.find<ChatController>();
        if (chatController.roomId == incomingRoomId) {
          AppLog.printLog(
            'Notification suppressed: User is already in this chat room ($incomingRoomId)',
          );
          return;
        }
      }
    }

    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: 'ic_notification',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleMessageNavigationFromMap(Map<String, dynamic> data) {
    AppLog.printLog("RemoteMessage Data ===> ${data.toString()}");

    String? type = data['type']?.toString();
    String? senderId = data['senderId']?.toString();
    String? senderName = data['senderName']?.toString();
    String? senderImage = data['senderImage']?.toString();
    String? senderRole = data['senderRole']?.toString();
    String? roomId = data['roomId']?.toString();
    String? orderId = data['orderId']?.toString();

    AppLog.printLog("type ===> $type");
    AppLog.printLog("senderId ===> $senderId");
    AppLog.printLog("senderName ===> $senderName");
    AppLog.printLog("senderRole ===> $senderRole");
    AppLog.printLog("roomId ===> $roomId");
    AppLog.printLog("orderId ===> $orderId");

    if (AppUtils.checkUserLogin()) {
      if (type == 'chat_message' || type == 'new_message') {
        Get.to(
          ChatScreen(),
          arguments: {
            'otherUserId': senderId,
            'otherUserName': senderName,
            'otherUserImage': senderImage,
            'otherUserRole': senderRole,
            'roomId': roomId,
            'orderId': orderId,
          },
        );
      }
    }
  }
}
