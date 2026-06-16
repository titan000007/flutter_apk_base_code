import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import '../../../../utils/app_log.dart';

class FCMNotificationService {
  static final FCMNotificationService instance =
      FCMNotificationService._internal();
  factory FCMNotificationService() => instance;
  FCMNotificationService._internal();

  static const String _projectId = 'uber-for-boats';

  // Cache for access token
  String? _cachedAccessToken;
  DateTime? _tokenExpiryTime;

  Future<String?> _getAccessToken() async {
    try {
      // Return cached token if still valid
      if (_cachedAccessToken != null &&
          _tokenExpiryTime != null &&
          DateTime.now().isBefore(_tokenExpiryTime!)) {
        return _cachedAccessToken;
      }

      AppLog.printLog('Requesting new FCM access token...');

      // Use direct Map instead of json.decode to avoid \n parsing issue
      final accountCredentials = ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "uber-for-boats",
        "private_key_id": "c71f062769f2954395d785b47d424633c9a78c87",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDzAYZGbP8ezjlD\nyaZ8wXDbMdfdHpVIwH4DDPzXsuEQAuO6Pr89jiWgioE4i4hKmvUy6LM9C51ifJ10\nnERoJccveQOmu2lM7/+EA7QaEOjyCj9z9eQ6YG3RaVLX1pwwP9lqSdZi1rakp3CY\nW/OS8YHZPX06EZsdWdsbPA7iRrRIWYWq47yalboJ4VaoQiGDwTUJK+66y3oLqgZN\n1gA2lTeHDpYbax/lTshzNOsDKZ5RR0/PDc4xaK/77wyV8J/6sNXX0Ia8tfM+fDBE\ndy+B8V12cnl2phmgGBU2I1zPDcmGlw7Rt+NTYwqkGl4zYmBtWv7YoIdv/nnynRAK\n7tBElDrTAgMBAAECggEAB3sRCKL7WZXsol8XTnjgAgdvR0HVQ6eVWX+xWuyJTCZi\nn02mMn1pQB9zaeu1tuI9USNjvSnZ3vnKGRhkbLZZAuedSqkzTSiIO6aniTPjD+xr\n1qSHsZpdVxiAcd+L8FpO1ZxPSrykY745057lCS2BG1BuxfZbyZQGEDkRljqp+x4j\nCUfMRk60vY7MaQtVoTzGvsPuLX3PX/zM8go9LWW1fMnbr5VJzdafhYU2zxnKfl0c\nXqg9SfFFoyz8nJfYC3u7lAe/Br1g1LQJjNgTgH8jXhEKlUN+Yu+hoixbhbs38LRc\ngNHAk3dEvHI00T+tBELNmelmwhKCrKz6mp1FYUIYGQKBgQD8KdiiWxe07gL+1ZUk\nfy2RNLQgpsGXf4GLK4612nb0TRJt3V19EzcnpTDUqtjLfNJp6FschJG5ILdmknWW\nvAiGD6KiFJM271yWMA4AY+ZKHTRYy1ZBMzWKLTcFoSs2XUJaYYSvY6WnXWavOGW2\nWNMYnAHUIrHVj98/R2G+x1w0mwKBgQD2tAK4h5Ftka5BgqQFQa+fEPjb607+TG/t\nrA6rikHObMKt7ZvETbEutnKxfbxJg/7MLAeG06kFI1ai9UZLwcNElRCjT3OuqHh0\nucurhgL4zXw4nNYz27iIphPHRmhbuGyY4Vps0Z+LB2QnV0zTM1MROaM/M4G20xU0\n/rKQoQFKKQKBgQDuUdJXp4YhTq1wEYYSZ0w2pzvyfAgNWcmiMXmAL8grHkhjo0p/\nMlD3XC1pYUriDseCpsKtkjFzaRNMkvElk/LuWQqY6p8z1UeI/kPNZJ06wJ0/qnWL\ny403WYJeBLOlfsB+URoo9SGTqzeoNMIUc6CW6qLjziKKt54D3T/pIdvoLwKBgQCB\nFDqANl5/B8Q2/pW3MmEjRwwOdRYFtBS0NFwQoOxBh2JtAm+HzGayXD+yYmlLxcZh\nKYBeqQw8ZfsElHTNWnpCvgPQjtemQPuVh0jrW9jeORWPwW/J/mKVDOA4WbxskRgw\n/WgEm8FwStO6SdEmiCokTxX9EYQDFnp4GfNv/O3h0QKBgAJUm5XEuviRMCc7Pscr\nY4OtVzj6vJn7RrIWUklVRkiEDPcEpxdP61tDNsSmxd4fOJsbjGXZ2GypYTTnqamu\nBInYTrvtW4UeeqW6Ul47/jU+Vbp9MIe+gZ4/fMrU2rDa2/zNhSCOrBwaziYSLmX4\nghwE4fUAAgP2oFIZmho4Vmpq\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@uber-for-boats.iam.gserviceaccount.com",
        "client_id": "103495077184436192452",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40uber-for-boats.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      });

      const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final client = http.Client();
      try {
        final accessCredentials =
            await obtainAccessCredentialsViaServiceAccount(
              accountCredentials,
              scopes,
              client,
            );

        _cachedAccessToken = accessCredentials.accessToken.data;
        _tokenExpiryTime = accessCredentials.accessToken.expiry;

        AppLog.printLog('FCM Access token obtained');
        return _cachedAccessToken;
      } finally {
        client.close();
      }
    } catch (e) {
      AppLog.printLog('Error getting FCM access token: $e');
      return null;
    }
  }

  Future<bool> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    String? receiverId,
    String receiverCollection = 'chat_rooms',
    Map<String, dynamic>? data,
  }) async {
    try {
      if (fcmToken.isEmpty) {
        AppLog.printLog('FCM token is empty');
        return false;
      }

      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        AppLog.printLog('Failed to get access token');
        return false;
      }

      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
      );

      final message = {
        'message': {
          'token': fcmToken,
          'notification': {'title': title, 'body': body},
          if (data != null && data.isNotEmpty)
            'data': data.map((k, v) => MapEntry(k, v.toString())),
          'android': {
            'priority': 'high',
            'notification': {
              'sound': 'default',
              'channel_id': 'high_importance_channel',
            },
          },
          'apns': {
            'payload': {
              'aps': {'sound': 'default', 'badge': 1},
            },
          },
        },
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(message),
      );
      if (response.statusCode == 404) {
        final body = response.body;

        if (body.contains('UNREGISTERED')) {
          AppLog.printLog(' Token expired, delete from DB');

          if (receiverId != null) {
            await FirebaseFirestore.instance
                .collection(receiverCollection)
                .doc(receiverId)
                .update({'fcmToken': FieldValue.delete()});
          }
        }
      }

      if (response.statusCode == 200) {
        AppLog.printLog('Notification sent successfully');
        return true;
      } else {
        AppLog.printLog('Failed: ${response.statusCode} — ${response.body}');
        if (response.statusCode == 401) _cachedAccessToken = null;
        return false;
      }
    } catch (e) {
      AppLog.printLog('Error sending notification: $e');
      return false;
    }
  }
}
