class UserProfileResponse {
  final bool status;
  final String message;
  final UserProfileData data;

  UserProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      status: json['status'],
      message: json['message'],
      data: UserProfileData.fromJson(json['data']),
    );
  }
}

class UserProfileData {
  final int id;
  final String email;
  final int role;
  final bool isVerified;
  final bool isActive;
  final String? profileImage;
  final String? coverPhoto;
  final String createdAt;
  final String updatedAt;
  final Employee employee;

  UserProfileData({
    required this.id,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    this.profileImage,
    this.coverPhoto,
    required this.createdAt,
    required this.updatedAt,
    required this.employee,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      isVerified: json['is_verified'],
      isActive: json['is_active'],
      profileImage: json['profile_image'],
      coverPhoto: json['cover_photo'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      employee: Employee.fromJson(json['employee']),
    );
  }
}

class Employee {
  final String name;
  final String initials;
  final String experienceYears;
  final String country;
  final String state;
  final String city;
  final String dob;
  final String gender;
  final int height;
  final ColorInfo eyeColor;
  final ColorInfo hairColor;
  final bool isAvailable;
  final Skill skill;
  final String? resumePath;

  Employee({
    required this.name,
    required this.initials,
    required this.experienceYears,
    required this.country,
    required this.state,
    required this.city,
    required this.dob,
    required this.gender,
    required this.height,
    required this.eyeColor,
    required this.hairColor,
    required this.isAvailable,
    required this.skill,
    this.resumePath,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'],
      initials: json['initials'],
      experienceYears: json['experience_years'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      dob: json['dob'],
      gender: json['gender'],
      height: json['height'],
      eyeColor: ColorInfo.fromJson(json['eye_color']),
      hairColor: ColorInfo.fromJson(json['hair_color']),
      isAvailable: json['is_available'],
      skill: Skill.fromJson(json['skill']),
      resumePath: json['resume_path'],
    );
  }
}

class ColorInfo {
  final int id;
  final String name;

  ColorInfo({required this.id, required this.name});

  factory ColorInfo.fromJson(Map<String, dynamic> json) {
    return ColorInfo(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Skill {
  final int id;
  final String name;

  Skill({required this.id, required this.name});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
    );
  }
}
