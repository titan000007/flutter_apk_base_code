// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../../../../common_widgets/back_button.dart';
// import '../../../../../utils/app_color.dart';
// import '../chat_service/chat_helper.dart';
// import '../controllers/chat_list_controller.dart';
//
//
// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ChatListController());
//
//     return Scaffold(
//       backgroundColor: AppColor.appColor,
//       appBar: AppBar(
//         backgroundColor: AppColor.appColor,
//         leadingWidth: 48,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 14, top: 12, bottom: 12),
//           child: BackButtonWidget(onTap: () => Get.back()),
//         ),
//         title: const Text(
//           'Messages',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: AppColor.whiteColor,
//           ),
//         ),
//         actions: [
//           Obx(() {
//             if (controller.unreadCount.value > 0) {
//               return Padding(
//                 padding: const EdgeInsets.only(right: 16),
//                 child: Center(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       '${controller.unreadCount.value}',
//                       style: const TextStyle(
//                         color: AppColor.whiteColor,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }
//             return const SizedBox.shrink();
//           }),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(
//               color: AppColor.blueTextColor,
//             ),
//           );
//         }
//
//         if (controller.chatRooms.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.chat_bubble_outline,
//                   size: 80,
//                   color: AppColor.whiteColor.withOpacity(0.3),
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   'No conversations yet',
//                   style: TextStyle(
//                     color: AppColor.whiteColor.withOpacity(0.6),
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Start chatting with roommates or landlords',
//                   style: TextStyle(
//                     color: AppColor.whiteColor.withOpacity(0.4),
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return RefreshIndicator(
//           onRefresh: controller.loadChatRooms,
//           color: AppColor.blueTextColor,
//           child: ListView.builder(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             itemCount: controller.chatRooms.length,
//             itemBuilder: (context, index) {
//               final room = controller.chatRooms[index];
//               final otherUser = room['other_user'];
//
//               return _ChatListTile(
//                 room: room,
//                 otherUser: otherUser,
//                 onTap: () async {
//                   await ChatHelper.openChat(
//                     otherUserId: otherUser['id'],
//                     otherUserName: otherUser['name'] ?? 'User',
//                     otherUserImage: otherUser['profile_image'],
//                     otherUserRole: otherUser['role'],
//                   );
//                   // Reload chat list after returning
//                   controller.loadChatRooms();
//                 },
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
// }
//
// class _ChatListTile extends StatelessWidget {
//   final Map<String, dynamic> room;
//   final Map<String, dynamic> otherUser;
//   final VoidCallback onTap;
//
//   const _ChatListTile({
//     required this.room,
//     required this.otherUser,
//     required this.onTap,
//   });
//
//   String _formatTime(String? timestamp) {
//     if (timestamp == null) return '';
//
//     try {
//       final dateTime = DateTime.parse(timestamp);
//       final now = DateTime.now();
//       final difference = now.difference(dateTime);
//
//       if (difference.inMinutes < 1) {
//         return 'Just now';
//       } else if (difference.inHours < 1) {
//         return '${difference.inMinutes}m ago';
//       } else if (difference.inDays == 0) {
//         final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
//         final minute = dateTime.minute.toString().padLeft(2, '0');
//         final period = dateTime.hour >= 12 ? 'PM' : 'AM';
//         return '$hour:$minute $period';
//       } else if (difference.inDays == 1) {
//         return 'Yesterday';
//       } else if (difference.inDays < 7) {
//         final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//         return weekdays[dateTime.weekday - 1];
//       } else {
//         return '${dateTime.day}/${dateTime.month}';
//       }
//     } catch (e) {
//       return '';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final profileImage = otherUser['profile_image'] ?? '';
//     final userName = otherUser['name'] ?? 'User';
//     final userRole = otherUser['role'] ?? 'tenant';
//     final lastMessage = room['last_message'] ?? 'No messages yet';
//     final lastMessageTime = room['last_message_time'];
//
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           children: [
//             // Profile Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(30),
//               child: profileImage.isNotEmpty
//                   ? CachedNetworkImage(
//                 imageUrl: profileImage,
//                 width: 56,
//                 height: 56,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => Container(
//                   width: 56,
//                   height: 56,
//                   color: AppColor.otpFieldColor,
//                   child: Icon(
//                     Icons.person,
//                     color: AppColor.whiteColor.withOpacity(0.5),
//                     size: 28,
//                   ),
//                 ),
//                 errorWidget: (context, url, error) => Container(
//                   width: 56,
//                   height: 56,
//                   color: AppColor.otpFieldColor,
//                   child: Icon(
//                     Icons.person,
//                     color: AppColor.whiteColor.withOpacity(0.5),
//                     size: 28,
//                   ),
//                 ),
//               )
//                   : Container(
//                 width: 56,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   color: AppColor.otpFieldColor,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Icon(
//                   Icons.person,
//                   color: AppColor.whiteColor.withOpacity(0.5),
//                   size: 28,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Chat Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           userName,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: AppColor.whiteColor,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Text(
//                         _formatTime(lastMessageTime),
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w400,
//                           color: AppColor.whiteColor.withOpacity(0.5),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: userRole == 'landlord'
//                               ? AppColor.blueTextColor.withOpacity(0.2)
//                               : AppColor.otpFieldColor,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           userRole.capitalizeFirst ?? '',
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w500,
//                             color: userRole == 'landlord'
//                                 ? AppColor.blueTextColor
//                                 : AppColor.whiteColor.withOpacity(0.7),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           lastMessage,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                             color: AppColor.whiteColor.withOpacity(0.6),
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             const Icon(
//               Icons.chevron_right,
//               color: AppColor.whiteColor,
//               size: 24,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }