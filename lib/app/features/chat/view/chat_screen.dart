import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uber_boats_customer/common_widgets/back_button.dart';
import 'package:uber_boats_customer/utils/app_color.dart';
import '../../../../common_widgets/my_dialog.dart';
import '../controllers/chat_controller.dart';
import 'widget/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = Get.put(ChatController());
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (chatController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1A9E8F)),
          );
        }
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              if (!chatController.isChatAvailable.value)
                _buildChatUnavailableBanner(),
              Expanded(child: _buildMessagesList()),
              if (chatController.isChatAvailable.value) _buildInputField(),
            ],
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.pageBackground,
      leadingWidth: 48,
      leading: Padding(
        padding: const EdgeInsets.only(left: 14, top: 12, bottom: 12),
        child: BackButtonWidget(onTap: () => Get.back()),
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: chatController.otherUserImage.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: chatController.otherUserImage,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _avatarPlaceholder(),
                    errorWidget: (context, url, error) => _avatarPlaceholder(),
                  )
                : _avatarPlaceholder(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatController.otherUserName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.appBlackColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                if (chatController.otherUserRole.isNotEmpty)
                  Text(
                    chatController.otherUserRole.capitalizeFirst ?? '',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColor.hintTextColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: 42,
      height: 42,
      color: const Color(0xFFDDEEEC),
      child: const Icon(Icons.person, color: Color(0xFF888888)),
    );
  }

  Widget _buildChatUnavailableBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: const Color(0xFFFFF3CD),
      child: Row(
        children: const [
          Icon(Icons.lock_outline, size: 16, color: Color(0xFF856404)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Chat is only available during active delivery',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF856404),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Obx(() {
      if (chatController.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: Color(0xFFCCCCCC),
              ),
              SizedBox(height: 12),
              Text(
                'No messages yet',
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Start a conversation!',
                style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
              ),
            ],
          ),
        );
      }

      return ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: chatController.messages.length,
          reverse: true,
          itemBuilder: (context, index) {
            final message = chatController.messages[index];
            final isMe = chatController.isMyMessage(message);

            return ChatBubble(
              text: message['message'] ?? '',
              // 'message' field (existing structure)
              isMe: isMe,
              time: chatController.formatMessageTime(message['createdAt']),
              // 'createdAt'
              imageUrl: message['imageUrl'],
              // 'imageUrl'
              isRead: message['isRead'] ?? false,
              // 'isRead'
              onImageTap:
                  message['imageUrl'] != null &&
                      message['imageUrl'].toString().isNotEmpty
                  ? () => _showFullScreenImage(message['imageUrl'])
                  : null,
              onLongPress: isMe && chatController.isChatAvailable.value
                  ? () => _showDeleteDialog(message['id'], message['imageUrl'])
                  : null,
            );
          },
        ),
      );
    });
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  cursorColor: const Color(0xFF1A9E8F),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 5,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  onChanged: (value) {
                    chatController.messageText.value = value;
                    chatController.onTextChanged(value);
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 18,
                    ),
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColor.hintTextColor,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty &&
                        !chatController.isSending.value) {
                      chatController.sendMessage(value.trim());
                      _messageController.clear();
                      chatController.messageText.value = '';
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Obx(() {
              return GestureDetector(
                onTap: chatController.isSending.value
                    ? null
                    : () {
                        if (_messageController.text.trim().isNotEmpty) {
                          chatController.sendMessage(
                            _messageController.text.trim(),
                          );
                          _messageController.clear();
                          chatController.messageText.value = '';
                        }
                      },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColor.gradientFirstColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: chatController.isSending.value
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.black87,
                child: Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(String messageId, String? imageUrl) {
    Get.dialog(
      MyDialog(
        isLoading: false,
        title: 'Delete Message',
        description: 'Are you sure you want to delete this message?',
        icon: const Icon(Icons.delete_outline, color: AppColor.whiteColor),
        onPress: () {
          Get.back();
          chatController.deleteMessage(messageId, imageUrl);
        },
      ),
    );
  }
}
