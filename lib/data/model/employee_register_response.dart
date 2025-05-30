
import 'color_response.dart';

class RegisterResponse {
  final bool status;
  final String message;
  final RegisterData data;

  RegisterResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: RegisterData.fromJson(json['data'] ?? {}),
    );
  }
}

class RegisterData {
  final User user;
  final String token;

  RegisterData({
    required this.user,
    required this.token,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      user: User.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
    );
  }
}

class User {
  final int id;
  final String email;
  final int role;
  final bool? isVerified;
  final bool? isActive;
  final String createdAt;
  final String updatedAt;
  final Employee employee;
  final String? profileImage;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.isVerified,
    this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.employee,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      role: json['role'] ?? 0,
      isVerified: json['is_verified'],
      isActive: json['is_active'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      profileImage: json['profile_image'],
      employee: Employee.fromJson(json['employee'] ?? {}
      ),
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
  final EyeColor eyeColor;
  final HairColor hairColor;
  final String? resumePath;
  final bool isAvailable;
  final Skill skill;

  Employee({
    required this.name,
    required this.experienceYears,
    required this.country,
    required this.state,
    required this.city,
    required this.dob,
    required this.gender,
    required this.height,
    required this.eyeColor,
    required this.hairColor,
    this.resumePath,
    required this.isAvailable,
    required this.skill,
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
      eyeColor: EyeColor.fromJson(json['eye_color'] ?? {}),
      hairColor: HairColor.fromJson(json['hair_color'] ?? {}),
      resumePath: json['resume_path'],
      isAvailable: json['is_available'] ?? false,
      skill: Skill.fromJson(json['skill'] ?? {}),
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