import 'dart:convert';

class NotificationResponse {
  final bool status;
  final String message;
  final List<AppNotification> data;

  NotificationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => AppNotification.fromJson(e))
          .toList(),
    );
  }
}

class AppNotification {
  final int id;
  final int userId;
  final String type;
  final String title;
  final String message;
  final NotificationData? data;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.data,
    required this.isRead,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      data: json['data'] != null
          ? NotificationData.fromJson(jsonDecode(json['data']))
          : null,
      isRead: json['is_read'],
      readAt:
      json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class NotificationData {
  final int jobId;
  final String jobTitle;
  final String employerName;

  NotificationData({
    required this.jobId,
    required this.jobTitle,
    required this.employerName,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      jobId: json['job_id'],
      jobTitle: json['job_title'],
      employerName: json['employer_name'],
    );
  }
}
