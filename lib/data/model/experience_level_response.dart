// experience_level_model.dart

class ExperienceLevelResponse {
  final bool status;
  final String message;
  final List<ExperienceLevel> data;

  ExperienceLevelResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ExperienceLevelResponse.fromJson(Map<String, dynamic> json) {
    return ExperienceLevelResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => ExperienceLevel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class ExperienceLevel {
  final String id;
  final String name;

  ExperienceLevel({
    required this.id,
    required this.name,
  });

  factory ExperienceLevel.fromJson(Map<String, dynamic> json) {
    return ExperienceLevel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
