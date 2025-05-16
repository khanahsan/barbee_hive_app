class SkillsResponse {
  final bool status;
  final String message;
  final List<Skill> data;

  SkillsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SkillsResponse.fromJson(Map<String, dynamic> json) {
    return SkillsResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class EyeColorResponse {
  final bool status;
  final String message;
  final List<EyeColor> data;

  EyeColorResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EyeColorResponse.fromJson(Map<String, dynamic> json) {
    return EyeColorResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => EyeColor.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class HairColorResponse {
  final bool status;
  final String message;
  final List<HairColor> data;

  HairColorResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HairColorResponse.fromJson(Map<String, dynamic> json) {
    return HairColorResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => HairColor.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class Skill {
  final int id;
  final String name;

  Skill({
    required this.id,
    required this.name,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class EyeColor {
  final int id;
  final String name;

  EyeColor({
    required this.id,
    required this.name,
  });

  factory EyeColor.fromJson(Map<String, dynamic> json) {
    return EyeColor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class HairColor {
  final int id;
  final String name;

  HairColor({
    required this.id,
    required this.name,
  });

  factory HairColor.fromJson(Map<String, dynamic> json) {
    return HairColor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}