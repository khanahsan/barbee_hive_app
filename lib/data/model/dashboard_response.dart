
class DashboardResponse {
  final bool status;
  final String message;
  final DashboardData data;

  DashboardResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    print('Dashboard JSON: $json');
    return DashboardResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: DashboardData.fromJson(json['data']),
    );
  }
}

class DashboardData {
  final List<User> employees;
  final List<User> employers;

  DashboardData({
    required this.employees,
    required this.employers,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      employees: (json['employees'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      employers: (json['employers'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class User {
  final int id;
  final String email;
  final int role;
  final bool isVerified;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final Employee? employee;
  final Employer? employer;
  final String profileImage;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.employee,
    this.employer,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print('User JSON: $json');
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      role: json['role'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      profileImage: json['profile_image'] ?? '',
      employee: json['employee'] != null && json['employee'] is Map
          ? Employee.fromJson(json['employee'])
          : null,
      employer: json['employer'] != null && json['employer'] is Map
          ? Employer.fromJson(json['employer'])
          : null,
    );
  }
}

class Employee {
  final String name;
  final String experienceYears;
  final String country;
  final String state;
  final String city;
  final String dob;
  final String gender;
  final int height;
  final EyeColor? eyeColor;
  final HairColor? hairColor;
  final String? resumePath;
  final bool isAvailable;
  final Skill? skill;

  Employee({
    required this.name,
    required this.experienceYears,
    required this.country,
    required this.state,
    required this.city,
    required this.dob,
    required this.gender,
    required this.height,
    this.eyeColor,
    this.hairColor,
    this.resumePath,
    required this.isAvailable,
    this.skill,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'] ?? '',
      experienceYears: json['experience_years'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      height: json['height'] ?? 0,
      eyeColor: json['eye_color'] != null ? EyeColor.fromJson(json['eye_color']) : null,
      hairColor: json['hair_color'] != null ? HairColor.fromJson(json['hair_color']) : null,
      resumePath: json['resume_path'],
      isAvailable: json['is_available'] ?? false,
      skill: json['skill'] != null ? Skill.fromJson(json['skill']) : null,
    );
  }
}

class Employer {
  final String businessName;
  final String country;
  final String state;
  final String city;
  final PositionSeeking? positionSeeking;

  Employer({
    required this.businessName,
    required this.country,
    required this.state,
    required this.city,
    this.positionSeeking,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      businessName: json['business_name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      positionSeeking: json['position_seeking'] != null
          ? PositionSeeking.fromJson(json['position_seeking'])
          : null,
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

class PositionSeeking {
  final int id;
  final String name;

  PositionSeeking({
    required this.id,
    required this.name,
  });

  factory PositionSeeking.fromJson(Map<String, dynamic> json) {
    return PositionSeeking(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}