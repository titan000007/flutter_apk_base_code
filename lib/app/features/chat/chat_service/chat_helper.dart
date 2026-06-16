import 'package:get/get.dart';
import 'package:uber_boats_customer/app/features/chat/view/chat_screen.dart';
import '../controllers/chat_controller.dart';

class ChatHelper {
  /// Open chat with another user (roommate to roommate OR tenant to landlord)
  ///
  /// Example usage for roommate to roommate:
  /// ```dart
  /// ChatHelper.openChat(
  ///   otherUserId: roommateProfile['user_id'],
  ///   otherUserName: roommateProfile['name'],
  ///   otherUserImage: roommateProfile['profile_image'],
  ///   otherUserRole: 'tenant',
  /// );
  /// ```
  ///
  /// Example usage for tenant to landlord:
  /// ```dart
  /// ChatHelper.openChat(
  ///   otherUserId: landlordId,
  ///   otherUserName: landlordName,
  ///   otherUserImage: landlordImage,
  ///   otherUserRole: 'landlord',
  /// );
  /// ```
  static Future<void> openChat({
    required String otherUserId,
    required String otherUserName,
    String? otherUserImage,
    String? otherUserRole,
  }) async {
    // Initialize controller with dependency injection
    if (!Get.isRegistered<ChatController>()) {
      Get.put(ChatController(otherUserId: '', otherUserName: '', otherUserImage: '', otherUserRole: '', orderId: ''));
    }

    // Navigate to chat screen with arguments
    await Get.toNamed(
      await Get.to(() => const ChatScreen()),
      arguments: {
        'otherUserId': otherUserId,
        'otherUserName': otherUserName,
        'otherUserImage': otherUserImage ?? '',
        'otherUserRole': otherUserRole ?? 'tenant',
      },
    );

    // Clean up controller after leaving chat
    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>();
    }
  }

  /// Open chat from roommate profile_section card
  ///
  /// Use this when user clicks on a roommate profile_section
  static Future<void> openChatFromRoommateProfile(
      Map<String, dynamic> roommateProfile,
      ) async {
    await openChat(
      otherUserId: roommateProfile['user_id'],
      otherUserName: roommateProfile['name'] ?? 'Roommate',
      otherUserImage: roommateProfile['profile_image'],
      otherUserRole: 'tenant',
    );
  }

  /// Open chat from room details (tenant to landlord)
  ///
  /// Use this when tenant wants to contact the landlord
  static Future<void> openChatFromRoom(
      Map<String, dynamic> roomData,
      ) async {
    await openChat(
      otherUserId: roomData['landlord_id'] ?? roomData['owner_id'],
      otherUserName: roomData['landlord_name'] ?? roomData['owner_name'] ?? 'Owner',
      otherUserImage: roomData['landlord_image'] ?? roomData['owner_image'],
      otherUserRole: 'landlord',
    );
  }

  /// Open chat from user data directly
  ///
  /// Use this when you have user data from users table
  static Future<void> openChatFromUserData(
      Map<String, dynamic> userData,
      ) async {
    await openChat(
      otherUserId: userData['id'],
      otherUserName: userData['name'] ?? 'User',
      otherUserImage: userData['profile_image'],
      otherUserRole: userData['role'] ?? 'tenant',
    );
  }
}

// ============================================================================
// EXAMPLE USAGE IN YOUR APP
// ============================================================================

/*
// Example 1: Open chat from roommate list
class RoommateCard extends StatelessWidget {
  final Map<String, dynamic> roommateProfile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await ChatHelper.openChatFromRoommateProfile(roommateProfile);
      },
      child: Card(
        child: ListTile(
          title: Text(roommateProfile['name'] ?? 'Roommate'),
          trailing: Icon(Icons.chat),
        ),
      ),
    );
  }
}

// Example 2: Open chat from room details (Contact Owner button)
class RoomDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> roomData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Room details...
          ElevatedButton(
            onPressed: () async {
              await ChatHelper.openChatFromRoom(roomData);
            },
            child: Text('Contact Owner'),
          ),
        ],
      ),
    );
  }
}

// Example 3: Open chat with any user by ID
void contactUser(String userId, String userName) async {
  await ChatHelper.openChat(
    otherUserId: userId,
    otherUserName: userName,
    otherUserRole: 'tenant',
  );
}

// Example 4: Open chat from search results
class SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user['name']),
      trailing: IconButton(
        icon: Icon(Icons.chat_bubble),
        onPressed: () async {
          await ChatHelper.openChatFromUserData(user);
        },
      ),
    );
  }
}
*/