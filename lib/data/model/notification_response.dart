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
    NotificationData? parsedData;
    final rawData = json['data'];
    if (rawData != null && rawData is String && rawData.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawData);
        if (decoded is Map<String, dynamic>) {
          parsedData = NotificationData.fromJson(decoded);
        }
      } catch (_) {
        parsedData = null;
      }
    }

    return AppNotification(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      data: parsedData,
      isRead: json['is_read'],
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class NotificationData {
  final int? applicationId;
  final int? jobId;
  final String? jobTitle;
  final String? applicantName;
  final int? applicantId;
  final String? employerName;

  NotificationData({
    required this.applicationId,
    required this.jobId,
    required this.jobTitle,
    required this.applicantName,
    required this.applicantId,
    required this.employerName,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      applicationId: json['application_id'] is int
          ? json['application_id']
          : int.tryParse(json['application_id']?.toString() ?? ''),
      jobId: json['job_id'] is int
          ? json['job_id']
          : int.tryParse(json['job_id']?.toString() ?? ''),
      jobTitle: json['job_title']?.toString(),
      applicantName: json['applicant_name']?.toString(),
      applicantId: json['applicant_id'] is int
          ? json['applicant_id']
          : int.tryParse(json['applicant_id']?.toString() ?? ''),
      employerName: json['employer_name']?.toString(),
    );
  }
}
