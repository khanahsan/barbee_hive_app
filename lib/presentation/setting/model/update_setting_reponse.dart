class UpdateSettingResponse {
  final bool status;
  final String? message;
  final SettingData? data;

  UpdateSettingResponse({
    required this.status,
    this.message,
    this.data,
  });

  factory UpdateSettingResponse.fromJson(Map<String, dynamic> json) {
    return UpdateSettingResponse(
      status: json['status'] ?? false,
      message: json['message'],
      data: json['data'] != null ? SettingData.fromJson(json['data']) : null,
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

class SettingData {
  final int id;
  final int userId;
  final bool receiveMessages;
  final bool sound;
  final bool vibrate;
  final bool location;
  final int showDistance;
  final String createdAt;
  final String updatedAt;

  SettingData({
    required this.id,
    required this.userId,
    required this.receiveMessages,
    required this.sound,
    required this.vibrate,
    required this.location,
    required this.showDistance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SettingData.fromJson(Map<String, dynamic> json) {
    return SettingData(
      id: json['id'],
      userId: json['user_id'],
      receiveMessages: json['receive_messages'] ?? false,
      sound: json['sound'] ?? false,
      vibrate: json['vibrate'] ?? false,
      location: json['location'] ?? false,
      showDistance: json['show_distance'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'receive_messages': receiveMessages,
      'sound': sound,
      'vibrate': vibrate,
      'location': location,
      'show_distance': showDistance,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
