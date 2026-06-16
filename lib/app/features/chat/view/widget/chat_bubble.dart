import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../../utils/app_color.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final String? imageUrl;
  final VoidCallback? onLongPress;
  final VoidCallback? onImageTap;
  final bool isRead;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
    this.imageUrl,
    this.onLongPress,
    this.onImageTap,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? AppColor.gradientFirstColor
                      : AppColor.gradientFirstColor.withValues(alpha: .15),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomLeft: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(10),
                    bottomRight: isMe
                        ? const Radius.circular(10)
                        : const Radius.circular(0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                      GestureDetector(
                        onTap: onImageTap,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 180,
                              color: Colors.black12,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 180,
                              color: Colors.black12,
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 40),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (text.isNotEmpty) const SizedBox(height: 8),
                    ],
                    if (text.isNotEmpty)
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: isMe
                              ? AppColor.whiteColor
                              : AppColor.appBlackColor,
                          height: 1.4,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 08,
                          fontWeight: FontWeight.w400,
                          color: isMe
                              ? AppColor.whiteColor.withValues(alpha: .90)
                              : AppColor.hintTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
