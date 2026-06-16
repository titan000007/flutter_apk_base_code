// import 'dart:io';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../../../app_service/supabase/supabase_service.dart';
// import '../../../../../utils/app_log.dart';
// import 'fcm_notification_service.dart';
//
// class ChatService {
//   static final ChatService instance = ChatService._internal();
//   final FCMNotificationService _fcmService =
//       FCMNotificationService.instance; // ✅ Use new service
//   factory ChatService() => instance;
//   ChatService._internal();
//
//   final SupabaseClient _client = SupabaseService.instance.client;
//
//   //  NEW: Track active chat room to suppress notifications
//   String? _activeChatRoomId;
//   String? _activeChatUserId;
//
//   // //  NEW: Set active chat room (called when user opens a chat)
//   // void setActiveChatRoom(String roomId, String userId) {
//   //   _activeChatRoomId = roomId;
//   //   _activeChatUserId = userId;
//   //   AppLog.printLog(' Active chat set: Room=$roomId, User=$userId');
//   // }
//
//   // // ✅ NEW: Clear active chat room (called when user leaves chat)
//   // void clearActiveChatRoom() {
//   //   AppLog.printLog('🔴 Clearing active chat: Room=$_activeChatRoomId');
//   //   _activeChatRoomId = null;
//   //   _activeChatUserId = null;
//   // }
//
//   // ✅ NEW: Check if notification should be suppressed
//   // bool _shouldSuppressNotification(String roomId, String receiverId) {
//   //   final shouldSuppress = _activeChatRoomId == roomId && _activeChatUserId != null;
//   //
//   //   if (shouldSuppress) {
//   //     AppLog.printLog('🔕 Notification suppressed - user is viewing this chat');
//   //   } else {
//   //     AppLog.printLog('🔔 Notification will be sent - user not in this chat');
//   //   }
//   //
//   //   return shouldSuppress;
//   // }
//
//   /// Get or create a chat room between two users
//   Future<String?> getOrCreateChatRoom(String otherUserId) async {
//     try {
//       final currentUserId = _client.auth.currentUser?.id;
//       if (currentUserId == null) {
//         throw Exception('User not authenticated');
//       }
//
//       AppLog.printLog(
//         'Getting/Creating chat room between $currentUserId and $otherUserId',
//       );
//
//       final result = await _client.rpc(
//         'get_or_create_chat_room',
//         params: {'p_user1_id': currentUserId, 'p_user2_id': otherUserId},
//       );
//
//       final roomId = result as String;
//       AppLog.printLog('Chat room ID: $roomId');
//       return roomId;
//     } catch (e, stackTrace) {
//       AppLog.printLog('Error getting/creating chat room: $e');
//       AppLog.printLog('Stack trace: $stackTrace');
//       return null;
//     }
//   }
//
//   /// Get user's chat rooms with last message info
//   Future<List<Map<String, dynamic>>> getChatRooms() async {
//     try {
//       final currentUserId = _client.auth.currentUser?.id;
//       if (currentUserId == null) return [];
//
//       final response = await _client
//           .from(SupabaseService.chatRoomsTable)
//           .select('''
//             id,
//             user1_id,
//             user2_id,
//             last_message,
//             last_message_time,
//             updated_at,
//             user1:user1_id(id, name, profile_image, role),
//             user2:user2_id(id, name, profile_image, role)
//           ''')
//           .or('user1_id.eq.$currentUserId,user2_id.eq.$currentUserId')
//           .order('updated_at', ascending: false);
//
//       AppLog.printLog('Fetched ${response.length} chat rooms');
//
//       return response.map<Map<String, dynamic>>((room) {
//         final isUser1 = room['user1_id'] == currentUserId;
//         final otherUser = isUser1 ? room['user2'] : room['user1'];
//
//         return {
//           'room_id': room['id'],
//           'other_user': otherUser,
//           'last_message': room['last_message'],
//           'last_message_time': room['last_message_time'],
//           'updated_at': room['updated_at'],
//         };
//       }).toList();
//     } catch (e, stackTrace) {
//       AppLog.printLog('Error fetching chat rooms: $e');
//       AppLog.printLog('Stack trace: $stackTrace');
//       return [];
//     }
//   }
//
//   /// Get messages for a specific chat room
//   Future<List<Map<String, dynamic>>> getMessages(String roomId) async {
//     try {
//       final response = await _client
//           .from(SupabaseService.messagesTable)
//           .select('''
//             id,
//             sender_id,
//             receiver_id,
//             message_text,
//             image_url,
//             is_read,
//             created_at
//           ''')
//           .eq('room_id', roomId)
//           .order('created_at', ascending: false)
//           .limit(100);
//
//       AppLog.printLog('Fetched ${response.length} messages');
//       return List<Map<String, dynamic>>.from(response);
//     } catch (e, stackTrace) {
//       AppLog.printLog('Error fetching messages: $e');
//       AppLog.printLog('Stack trace: $stackTrace');
//       return [];
//     }
//   }
//
//   /// ✅ Send a text message with notification (Direct FCM) - with suppression logic
//   Future<bool> sendTextMessage({
//     required String roomId,
//     required String receiverId,
//     required String messageText,
//   }) async {
//     try {
//       final currentUserId = _client.auth.currentUser?.id;
//       if (currentUserId == null) {
//         throw Exception('User not authenticated');
//       }
//
//       await _client.from(SupabaseService.messagesTable).insert({
//         'room_id': roomId,
//         'sender_id': currentUserId,
//         'receiver_id': receiverId,
//         'message_text': messageText,
//         'is_read': false,
//       });
//
//       AppLog.printLog('Text message sent successfully');
//
//       // ✅ SEND NOTIFICATION - Only if user is not viewing this chat
//       //if (!_shouldSuppressNotification(roomId, receiverId)) {
//       await _sendDirectFcmNotification(
//         receiverId: receiverId,
//         messageText: messageText,
//         isImage: false,
//       );
//       // }
//
//       return true;
//     } catch (e, stackTrace) {
//       AppLog.printLog('Error sending text message: $e');
//       AppLog.printLog('Stack trace: $stackTrace');
//       return false;
//     }
//   }
//
//   /// ✅ Upload image and send image message with notification (Direct FCM) - with suppression logic
//   Future<bool> sendImageMessage({
//     required String roomId,
//     required String receiverId,
//     required File imageFile,
//   }) async {
//     try {
//       final currentUserId = _client.auth.currentUser?.id;
//       if (currentUserId == null) {
//         throw Exception('User not authenticated');
//       }
//
//       final imageUrl = await _uploadChatImage(imageFile, currentUserId);
//       if (imageUrl == null) {
//         throw Exception('Failed to upload image');
//       }
//
//       await _client.from(SupabaseService.messagesTable).insert({
//         'room_id': roomId,
//         'sender_id': currentUserId,
//         'receiver_id': receiverId,
//         'image_url': imageUrl,
//         'is_read': false,
//       });
//
//       AppLog.printLog('Image message sent successfully');
//
//       // ✅ SEND NOTIFICATION - Only if user is not viewing this chat
//       //if (!_shouldSuppressNotification(roomId, receiverId)) {
//       await _sendDirectFcmNotification(
//         receiverId: receiverId,
//         messageText: '📷 Sent an image',
//         isImage: true,
//       );
//       //}
//
//       return true;
//     } catch (e, stackTrace) {
//       AppLog.printLog('Error sending image message: $e');
//       AppLog.printLog('Stack trace: $stackTrace');
//       return false;
//     }
//   }
//
//   /// ✅ SEND NOTIFICATION DIRECTLY TO FCM (Updated to fetch from users table)
//   Future<void> _sendDirectFcmNotification({
//     required String receiverId,
//     required String messageText,
//     required bool isImage,
//   }) async {
//     try {
//       final currentUserId = _client.auth.currentUser?.id;
//       if (currentUserId == null) return;
//
//       // Get sender's name from users table
//       final senderData = await _client
//           .from(SupabaseService.usersTable)
//           .select('*')
//           .eq('id', currentUserId)
//           .maybeSingle();
//
//       final senderName = senderData?['name'] ?? 'Someone';
//       final senderProfileImage = senderData?['profile_image'] ?? '';
//       final senderRole = senderData?['role'] ?? '';
//
//       // Get receiver's FCM token from users table
//       final receiverData = await _client
//           .from(SupabaseService.usersTable)
//           .select('fcmToken')
//           .eq('id', receiverId)
//           .maybeSingle();
//
//       if (receiverData == null || receiverData['fcmToken'] == null) {
//         AppLog.printLog('⚠️ No FCM token found for receiver: $receiverId');
//         return;
//       }
//
//       final fcmToken = receiverData['fcmToken'] as String;
//
//       // Check if token is empty
//       if (fcmToken.isEmpty) {
//         AppLog.printLog('⚠️ FCM token is empty for receiver: $receiverId');
//         return;
//       }
//
//       AppLog.printLog('📱 Receiver FCM token found: ${fcmToken.toString()}');
//       AppLog.printLog('Front User ID: ${currentUserId.toString()}');
//       AppLog.printLog('senderName: ${senderName.toString()}');
//       AppLog.printLog('senderProfileImage: ${senderProfileImage.toString()}');
//       AppLog.printLog('senderRole: ${senderRole.toString()}');
//
//       // ✅ USE NEW FCM NOTIFICATION SERVICE
//       final success = await _fcmService.sendNotification(
//         fcmToken: fcmToken.toString(),
//         title: senderName,
//         body: isImage ? '📷 Sent an image' : messageText,
//         data: {
//           'type': 'chat_message',
//           'room_id': _activeChatRoomId ?? '',
//           'timestamp': DateTime.now().toIso8601String(),
//           'senderId': currentUserId,
//           'senderName': senderName,
//           'senderImage': senderProfileImage,
//           'senderRole': senderRole,
//         },
//       );
//
//       if (success) {
//         AppLog.printLog(
//           '✅ Chat notification sent successfully via new FCM service',
//         );
//       } else {
//         AppLog.printLog('⚠️ Failed to send notification via FCM service');
//       }
//     } catch (e, stackTrace) {
//       AppLog.printLog('❌ Error sending chat notification: $e');
//       AppLog.printLog('Stack trace: $stackTrace');
//     }
//   }
//
//   /// Upload chat image to storage
//   Future<String?> _uploadChatImage(File imageFile, String userId) async {
//     try {
//       final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final filePath = '$userId/$fileName';
//
//       await _client.storage
//           .from(SupabaseService.chatImagesBucket)
//           .upload(filePath, imageFile);
//
//       final url = _client.storage
//           .from(SupabaseService.chatImagesBucket)
//           .getPublicUrl(filePath);
//
//       AppLog.printLog('Chat image uploaded: $url');
//       return url;
//     } catch (e, stackTrace) {
//       AppLog.printLog('Error uploading chat image: $e');
//       AppLog.printLog('Stack trace: $stackTrace');
//       return null;
//     }
//   }
//
//   /// Mark messages as read
//   Future<void> markMessagesAsRead(String roomId, String senderId) async {
//     try {
//       final currentUserId = _client.auth.currentUser?.id;
//       if (currentUserId == null) return;
//
//       await _client
//           .from(SupabaseService.messagesTable)
//           .update({'is_read': true})
//           .eq('room_id', roomId)
//           .eq('sender_id', senderId)
//           .eq('receiver_id', currentUserId)
//           .eq('is_read', false);
//
//       AppLog.printLog('Messages marked as read');
//     } catch (e, stackTrace) {
//       AppLog.printLog('Error marking messages as read: $e');
//       AppLog.printLog('Stack trace: $stackTrace');
//     }
//   }
//
//   /// Subscribe to new messages and updates in a chat room
//   RealtimeChannel subscribeToMessages({
//     required String roomId,
//     required Function(Map<String, dynamic>) onNewMessage,
//     Function(Map<String, dynamic>)? onMessageUpdate,
//   }) {
//     final channel = _client
//         .channel('messages:$roomId')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: SupabaseService.messagesTable,
//           filter: PostgresChangeFilter(
//             type: PostgresChangeFilterType.eq,
//             column: 'room_id',
//             value: roomId,
//           ),
//           callback: (payload) {
//             AppLog.printLog('New message received: ${payload.newRecord}');
//             onNewMessage(payload.newRecord);
//           },
//         )
//         .onPostgresChanges(
//           event: PostgresChangeEvent.update,
//           schema: 'public',
//           table: SupabaseService.messagesTable,
//           filter: PostgresChangeFilter(
//             type: PostgresChangeFilterType.eq,
//             column: 'room_id',
//             value: roomId,
//           ),
//           callback: (payload) {
//             AppLog.printLog('Message updated: ${payload.newRecord}');
//             if (onMessageUpdate != null) {
//               onMessageUpdate(payload.newRecord);
//             }
//           },
//         )
//         .subscribe();
//
//     AppLog.printLog('Subscribed to messages for room: $roomId');
//     return channel;
//   }
//
//   /// Unsubscribe from messages
//   Future<void> unsubscribeFromMessages(RealtimeChannel channel) async {
//     await _client.removeChannel(channel);
//     AppLog.printLog('Unsubscribed from messages');
//   }
//
//   /// Get unread message count for a user
//   Future<int> getUnreadMessageCount() async {
//     try {
//       final currentUserId = _client.auth.currentUser?.id;
//       if (currentUserId == null) return 0;
//
//       final response = await _client
//           .from('messages')
//           .select('id')
//           .eq('receiver_id', currentUserId)
//           .eq('is_read', false)
//           .count(CountOption.exact);
//
//       return response.count ?? 0;
//     } catch (e) {
//       AppLog.printLog('Error getting unread message count: $e');
//       return 0;
//     }
//   }
//
//   /// Delete a chat message
//   Future<bool> deleteMessage(String messageId, String? imageUrl) async {
//     try {
//       if (imageUrl != null && imageUrl.isNotEmpty) {
//         await _deleteChatImage(imageUrl);
//       }
//
//       await _client
//           .from(SupabaseService.messagesTable)
//           .delete()
//           .eq('id', messageId);
//
//       AppLog.printLog('Message deleted successfully');
//       return true;
//     } catch (e, stackTrace) {
//       AppLog.printLog('Error deleting message: $e');
//       AppLog.printLog('Stack trace: $stackTrace');
//       return false;
//     }
//   }
//
//   /// Delete chat image from storage
//   Future<void> _deleteChatImage(String imageUrl) async {
//     try {
//       final uri = Uri.parse(imageUrl);
//       final pathSegments = uri.pathSegments;
//
//       if (pathSegments.length >= 2) {
//         final userId = pathSegments[pathSegments.length - 2];
//         final fileName = pathSegments.last;
//         final filePath = '$userId/$fileName';
//
//         await _client.storage.from(SupabaseService.chatImagesBucket).remove([
//           filePath,
//         ]);
//
//         AppLog.printLog('Chat image deleted: $filePath');
//       }
//     } catch (e) {
//       AppLog.printLog('Error deleting chat image: $e');
//     }
//   }
// }
