class SettingsResponse {
  final bool status;
  final String message;
  final SettingsData? data;

  SettingsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory SettingsResponse.fromJson(Map<String, dynamic> json) {
    return SettingsResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? SettingsData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class SettingsData {
  final bool receiveMessages;
  final bool sound;
  final bool vibrate;
  final bool location;
  final int showDistance;
  final int userId;
  final String updatedAt;
  final String createdAt;
  final int id;

  SettingsData({
    required this.receiveMessages,
    required this.sound,
    required this.vibrate,
    required this.location,
    required this.showDistance,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory SettingsData.fromJson(Map<String, dynamic> json) {
    return SettingsData(
      receiveMessages: json['receive_messages'] ?? false,
      sound: json['sound'] ?? false,
      vibrate: json['vibrate'] ?? false,
      location: json['location'] ?? false,
      showDistance: json['show_distance'] ?? 0,
      userId: json['user_id'] ?? 0,
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receive_messages': receiveMessages,
      'sound': sound,
      'vibrate': vibrate,
      'location': location,
      'show_distance': showDistance,
      'user_id': userId,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
