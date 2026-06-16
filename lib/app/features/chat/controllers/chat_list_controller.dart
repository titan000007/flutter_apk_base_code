// import 'package:get/get.dart';
// import '../../../../../utils/app_log.dart';
// import '../chat_service/chat_service.dart';
//
// class ChatListController extends GetxController {
//   final ChatService _chatService = ChatService.instance;
//
//   var isLoading = false.obs;
//   var chatRooms = <Map<String, dynamic>>[].obs;
//   var unreadCount = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadChatRooms();
//     loadUnreadCount();
//   }
//
//   /// Load all chat rooms
//   Future<void> loadChatRooms() async {
//     try {
//       isLoading.value = true;
//       final rooms = await _chatService.getChatRooms();
//       chatRooms.value = rooms;
//       AppLog.printLog('Loaded ${rooms.length} chat rooms');
//     } catch (e) {
//       AppLog.printLog('Error loading chat rooms: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Load unread message count
//   Future<void> loadUnreadCount() async {
//     try {
//       final count = await _chatService.getUnreadMessageCount();
//       unreadCount.value = count;
//       AppLog.printLog('Unread messages: $count');
//     } catch (e) {
//       AppLog.printLog('Error loading unread count: $e');
//     }
//   }
// }