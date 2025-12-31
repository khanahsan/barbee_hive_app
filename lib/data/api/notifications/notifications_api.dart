
import '../../model/notification_response.dart';
import '../api_service.dart';
import '../endpoint_constants.dart';

class NotificationsApi {

  static Future<int> getUnreadCount() async {
    final data = await ApiService.get(ApiEndPoints.unreadCount, auth: true);
    print("data : msmsms ${data['data']['count']}");

    var count = data['data']['count'] ?? 0;

    return count;

  }


  static Future<List<AppNotification>> getAllNotifications() async {
    final response = await ApiService.get(
      "${ApiEndPoints.getAllNotifications}?limit=20&unread_only=false",
      auth: true,
    );

    // response is already decoded JSON from _handleResponse
    final notificationResponse = NotificationResponse.fromJson(response);

    return notificationResponse.data;
  }
  static Future<void> markAllAsRead() async {
     var data = await ApiService.put(
      ApiEndPoints.markAllAsRead,
      auth: true,
    );

     print("darttt : ${data}");
  }



}