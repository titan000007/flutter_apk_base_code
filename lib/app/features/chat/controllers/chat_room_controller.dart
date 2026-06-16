import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../app_service/network/network_service.dart';
import '../../../../app_service/network/network_urls.dart';
import '../../../../utils/app_log.dart';
import '../../../../utils/app_prompt.dart';
import '../../../../utils/app_string.dart';

class ChatRoomController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String roomsCollection = 'chat_rooms';

  // Create deterministic room id for two users (no duplicate rooms)
  String getRoomId(String a, String b) {
    final ids = [a, b]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Future<DocumentReference> createOrGetRoom({
    required String currentUserId,
    required String otherUserId,
    required String currentUserName,
    required String currentUserImage,
    required String otherUserName,
    required String otherUserImage,
  }) async {
    final roomId = getRoomId(currentUserId, otherUserId);
    final roomRef = _db.collection(roomsCollection).doc(roomId);

    final snapshot = await roomRef.get();
    if (snapshot.exists) {
      return roomRef;
    }

    final roomData = {
      'id': roomId,
      'memberIds': [currentUserId, otherUserId],
      'members': {
        currentUserId: {'name': currentUserName, 'image': currentUserImage},
        otherUserId: {'name': otherUserName, 'image': otherUserImage},
      },
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSenderId': '',
      'unread': {currentUserId: 0, otherUserId: 0},
      "blocked": {currentUserId: false, otherUserId: false},
      'typing': {currentUserId: false, otherUserId: false},
      'onlineStatus': {},
    };

    await roomRef.set(roomData);
    return roomRef;
  }

  Stream<QuerySnapshot> streamUserRooms(String userId, {String? search}) {
    // query rooms where userId is a member
    final baseQuery = _db
        .collection(roomsCollection)
        .where('memberIds', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true);

    if (search != null && search.trim().isNotEmpty) {
      // Client-side filtering after snapshot is simpler; Firestore text search needs indexing / third-party.
      return baseQuery.snapshots();
    } else {
      return baseQuery.snapshots();
    }
  }

  Future<void> resetUnread(String roomId, String userId) async {
    final roomRef = _db.collection(roomsCollection).doc(roomId);
    await roomRef.update({'unread.$userId': 0});
  }

  Future<void> setUserOnlineStatus({
    required String roomId,
    required String userId,
    required bool isOnline,
  }) async {
    final roomRef = _db.collection(roomsCollection).doc(roomId);
    await roomRef.update({'onlineStatus.$userId': isOnline});
  }

  Future<void> incrementUnread(String roomId, String otherUserId) async {
    final roomRef = _db.collection(roomsCollection).doc(roomId);
    await _db.runTransaction((tx) async {
      final s = await tx.get(roomRef);
      if (!s.exists) return;
      final unreadMap = Map<String, dynamic>.from(s.get('unread') ?? {});
      final prev = (unreadMap[otherUserId] ?? 0) as int;
      unreadMap[otherUserId] = prev + 1;
      tx.update(roomRef, {'unread': unreadMap});
    });
  }

  Future<void> blockUser({
    required String roomId,
    required String otherUserId,
  }) async {
    final roomRef = _db.collection(roomsCollection).doc(roomId);

    await roomRef.update({'blocked.$otherUserId': true});
    blockUserApiCall(id: otherUserId, type: 'block');
  }

  Future<void> unblockUser({
    required String roomId,
    required String otherUserId,
  }) async {
    final roomRef = _db.collection(roomsCollection).doc(roomId);

    await roomRef.update({'blocked.$otherUserId': false});
    blockUserApiCall(id: otherUserId, type: 'unblock');
  }

  ///Report and block user Api's
  reportUserApiCall({required String id, required String reasonOrText}) async {
    Map<String, dynamic> body = {"reason": reasonOrText};
    try {
      final response = await NetworkService().postApiCall(
        url: "${NetworkUrl.createOrder}/$id",
        body: body,
      );
      if (response != null) {
        // UserActionModel data = UserActionModel.fromJson(response);
        showAppToast(
          isForError: false,
          msg: response['msg'] ?? "",
        );
        Get.back();
      }
    } catch (e, stackTrace) {
      AppLog.printLog(
        "reportUserApiCall Api Error => ${stackTrace.toString()}",
      );
    }
  }

  blockUserApiCall({required String id, required String type}) async {
    try {
      final response = await NetworkService().postApiCall(
        url: "${NetworkUrl.createOrder}/$id",
        body: {
          "type": type.toString(), //add remove
        },
      );
      if (response != null) {
        // UserActionModel userActionModel = UserActionModel.fromJson(response);
        AppLog.printLog("userActionModel ::: ${response['msg']}");
        showAppToast(
          isForError: false,
          msg: response['msg'] ?? "",
        );
      }
    } catch (e, stackTrace) {
      showAppToast(
        isForError: true,
        msg: e.toString(),
      );
      AppLog.printLog("Action Api Error => ${stackTrace.toString()}");
    }
  }

  Future<dynamic> checkMatchAndPlanApi({required String id}) async {
    try {
      final response = await NetworkService().postApiCall(
        url: "${NetworkUrl.createOrder}/$id",
        body: {},
      );

      if (response != null) {
        // MatchAndPlanModel matchAndPlanModel = MatchAndPlanModel.fromJson(response);
        return response['data'] ?? {};
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      AppLog.printLog("CheckMatchAndPlanApi => ${stackTrace.toString()}");
      return null;
    }
  }

  Future<void> deleteChatRoom(String roomId, String currentUserId) async {
    final roomRef = _db.collection(roomsCollection).doc(roomId);

    try {
      AppLog.printLog("deleteChatRoom Chat Error => ");
      // If you want to delete the entire room (for both users)
      await roomRef.delete();
    } catch (e) {
      AppLog.printLog("Delete Chat Error => $e");
      rethrow;
    }
  }
}
