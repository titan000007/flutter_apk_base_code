import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uber_boats_customer/main.dart';
import 'package:uber_boats_customer/utils/shared_preferences.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_log.dart';
import '../../../../utils/app_prompt.dart';
import '../chat_service/fcm_notification_service.dart';

class ChatController extends GetxController {
  static String activeRoomId = '';
  final RxString _otherUserId = ''.obs;
  final RxString _otherUserName = ''.obs;
  final RxString _otherUserImage = ''.obs;
  final RxString _otherUserRole = ''.obs;
  final RxString _orderId = ''.obs;

  String get otherUserId => _otherUserId.value;
  String get otherUserName => _otherUserName.value;
  String get otherUserImage => _otherUserImage.value;
  String get otherUserRole => _otherUserRole.value;
  String get orderId => _orderId.value;

  ChatController({
    String otherUserId = '',
    String otherUserName = '',
    String otherUserImage = '',
    String otherUserRole = '',
    String orderId = '',
  }) {
    _otherUserId.value = otherUserId;
    _otherUserName.value = otherUserName;
    _otherUserImage.value = otherUserImage;
    _otherUserRole.value = otherUserRole;
    _orderId.value = orderId;
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _collection = 'chat_rooms';

  String get roomId {
    final ids = [currentUserId, otherUserId]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  var isLoading = false.obs;
  var isChatAvailable = true.obs;
  var messages = <Map<String, dynamic>>[].obs;
  var messageText = ''.obs;
  var isSending = false.obs;
  var isOtherUserTyping = false.obs;
  bool _typingDebounce = false;
  final RxInt unreadCount = 0.obs;

  String currentUserId = '';
  String currentUserName = '';
  String currentUserImage = '';

  @override
  void onInit() {
    super.onInit();

    currentUserId = sp?.getString(SpUtil.userID) ?? '';
    currentUserName = sp?.getString(SpUtil.userName) ?? '';
    currentUserImage = sp?.getString(SpUtil.userImage) ?? '';

    if (_otherUserId.value.isEmpty) {
      _otherUserId.value = Get.arguments?['otherUserId'] ?? '';
      _otherUserName.value = Get.arguments?['otherUserName'] ?? '';
      _otherUserImage.value = Get.arguments?['otherUserImage'] ?? '';
      _otherUserRole.value = Get.arguments?['otherUserRole'] ?? '';
      _orderId.value = Get.arguments?['orderId'] ?? '';
      activeRoomId = roomId;
    }

    AppLog.printLog('=== CHAT DEBUG ===');
    AppLog.printLog('currentUserId: $currentUserId');
    AppLog.printLog('otherUserId: $otherUserId');
    AppLog.printLog('otherUserRole: $otherUserRole');
    AppLog.printLog('orderId: $orderId');
    AppLog.printLog('roomId: $roomId');
    AppLog.printLog('==================');

    if (currentUserId.isNotEmpty && otherUserId.isNotEmpty) {
      setupChat();
    }
  }

  @override
  void onClose() {
    activeRoomId = '';
    _setTypingStatus(false);
    super.onClose();
  }

  void setupChat() async {
    isLoading.value = true;
    await _createOrGetRoom();
    _listenToMessages();
    _listenToTyping();
    _listenToUnreadCount();
    await markMessagesAsRead();
    isLoading.value = false;
  }

  Future<void> _createOrGetRoom() async {
    try {
      final roomRef = _db.collection(_collection).doc(roomId);
      final snapshot = await roomRef.get();

      if (!snapshot.exists) {
        await roomRef.set({
          'id': roomId,
          'orderId': orderId,
          'memberIds': [currentUserId, otherUserId],
          'members': {
            currentUserId: {'name': currentUserName, 'image': currentUserImage},
            otherUserId: {'name': otherUserName, 'image': otherUserImage},
          },
          'lastMessage': '',
          'lastMessageType': 'text',
          'lastMessageSenderId': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'typing': {currentUserId: false, otherUserId: false},
          'unread': {currentUserId: 0, otherUserId: 0},
        });
        AppLog.printLog('Chat room created: $roomId');
      } else {
        await roomRef.update({
          'members.$currentUserId.name': currentUserName,
          'members.$currentUserId.image': currentUserImage,
          'members.$otherUserId.name': otherUserName,
          'members.$otherUserId.image': otherUserImage,
        });
        AppLog.printLog('Chat room exists: $roomId');
      }
    } catch (e) {
      AppLog.printLog('_createOrGetRoom error: $e');
    }
  }

  void _listenToMessages() {
    _db
        .collection(_collection)
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          messages.value = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
          markMessagesAsRead();
        });
  }

  void _listenToTyping() {
    _db.collection(_collection).doc(roomId).snapshots().listen((snap) {
      if (snap.exists) {
        final data = snap.data();
        final typing = data?['typing'] as Map<String, dynamic>?;
        isOtherUserTyping.value = typing?[otherUserId] ?? false;
      }
    });
  }

  void _listenToUnreadCount() {
    _db.collection(_collection).doc(roomId).snapshots().listen((snap) {
      if (snap.exists) {
        final data = snap.data();
        final unread = data?['unread'] as Map<String, dynamic>?;
        unreadCount.value = (unread?[currentUserId] ?? 0) as int;
      }
    });
  }

  Future<void> markMessagesAsRead() async {
    if (roomId.isEmpty || currentUserId.isEmpty) return;
    try {
      await _db.collection(_collection).doc(roomId).update({
        'unread.$currentUserId': 0,
      });

      final unread = await _db
          .collection(_collection)
          .doc(roomId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId)
          .where('isRead', isEqualTo: false)
          .get();

      if (unread.docs.isEmpty) return;

      final batch = _db.batch();
      for (var doc in unread.docs) {
        batch.update(doc.reference, {
          'isRead': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    } catch (e) {
      AppLog.printLog('markMessagesAsRead error: $e');
    }
  }

  void onTextChanged(String text) {
    messageText.value = text;
    if (!_typingDebounce) {
      _typingDebounce = true;
      _setTypingStatus(true);
    }
    Future.delayed(const Duration(seconds: 2), () {
      _typingDebounce = false;
      if (messageText.value.isEmpty) _setTypingStatus(false);
    });
  }

  void _setTypingStatus(bool isTyping) {
    if (roomId.isEmpty || currentUserId.isEmpty) return;
    try {
      _db.collection(_collection).doc(roomId).update({
        'typing.$currentUserId': isTyping,
      });
    } catch (e) {
      AppLog.printLog('_setTypingStatus error: $e');
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || isSending.value) return;

    isSending.value = true;
    _setTypingStatus(false);

    try {
      await _db.collection(_collection).doc(roomId).collection('messages').add({
        'senderId': currentUserId,
        'receiverId': otherUserId,
        'message': text.trim(),
        'messageType': 'text',
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
        'imageUrl': null,
      });

      await _db.collection(_collection).doc(roomId).update({
        'lastMessage': text.trim(),
        'lastMessageType': 'text',
        'lastMessageSenderId': currentUserId,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unread.$otherUserId': FieldValue.increment(1),
      });

      messageText.value = '';
      _sendPushNotification(text.trim());
    } catch (e) {
      AppLog.printLog('sendMessage error: $e');
      showAppToast(msg: 'Failed to send message', isForError: true);
    } finally {
      isSending.value = false;
    }
  }

  Future<void> deleteMessage(String messageId, String? imageUrl) async {
    try {
      await _db
          .collection(_collection)
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .delete();
      showAppToast(msg: 'Message deleted');
    } catch (e) {
      AppLog.printLog('deleteMessage error: $e');
      showAppToast(msg: 'Failed to delete message', isForError: true);
    }
  }

  Future<void> _sendPushNotification(String message) async {
    try {
      final userDoc = await _db.collection('chat_rooms').doc(otherUserId).get();

      if (!userDoc.exists || userDoc.data()?['fcmToken'] == null) {
        AppLog.printLog(' No FCM token for: $otherUserId');
        return;
      }

      final fcmToken = userDoc.data()!['fcmToken'] as String;

      await FCMNotificationService.instance.sendNotification(
        fcmToken: fcmToken,
        title: currentUserName,
        body: message,
        receiverId: otherUserId,
        data: {
          'type': 'chat_message',
          'senderId': currentUserId,
          'senderName': currentUserName,
          'senderImage': currentUserImage,
          'senderRole': 'user',
          'roomId': roomId,
          'orderId': orderId,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
      );
    } catch (e) {
      AppLog.printLog('Error sending push notification: $e');
    }
  }

  bool isMyMessage(Map<String, dynamic> message) {
    return message['senderId'] == currentUserId;
  }

  String formatMessageTime(dynamic timestamp) {
    if (timestamp == null) return '';
    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is String) {
      try {
        dateTime = DateTime.parse(timestamp);
      } catch (_) {
        return '';
      }
    } else {
      return '';
    }
    return DateFormat('hh:mm a').format(dateTime);
  }
}
