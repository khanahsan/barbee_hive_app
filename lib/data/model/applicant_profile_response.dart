class ApplicantProfileResponse {
  final bool status;
  final String message;
  final ProfileData data;

  ApplicantProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApplicantProfileResponse.fromJson(Map<String, dynamic> json) {
    return ApplicantProfileResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ProfileData.fromJson(json['data']),
    );
  }
}

class ProfileData {
  final int id;
  final String email;
  final int role;
  final bool isVerified;
  final bool isActive;
  final String? profileImage;
  final String? coverPhoto;
  final String createdAt;
  final String updatedAt;
  final Employer? employer;
  final Employee? employee;

  ProfileData({
    required this.id,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    this.profileImage,
    this.coverPhoto,
    required this.createdAt,
    required this.updatedAt,
    this.employer,
    this.employee,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      role: json['role'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? false,
      profileImage: json['profile_image'],
      coverPhoto: json['cover_photo'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      employer: json['employer'] != null ? Employer.fromJson(json['employer']) : null,
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
    );
  }
}

class Employer {
  final String businessName;
  final String initials;
  final String country;
  final String state;
  final String city;
  final Skill? skill;

  Employer({
    required this.businessName,
    required this.initials,
    required this.country,
    required this.state,
    required this.city,
    this.skill,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      businessName: json['business_name'] ?? '',
      initials: json['initials'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      skill: json['skill'] != null ? Skill.fromJson(json['skill']) : null,
    );
  }
}

class Employee {
  final String? name;
  final String? initials;
  final int? experienceYears;
  final String? country;
  final String? state;
  final String? city;
  final String? dob;
  final String? gender;
  final int? height;
  final Color? eyeColor;
  final Color? hairColor;
  final String? resumePath;
  final bool? isAvailable;
  final Skill? skill;

  Employee({
    this.name,
    this.initials,
    this.experienceYears,
    this.country,
    this.state,
    this.city,
    this.dob,
    this.gender,
    this.height,
    this.eyeColor,
    this.hairColor,
    this.resumePath,
    this.isAvailable,
    this.skill,
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
      eyeColor: json['eye_color'] != null ? Color.fromJson(json['eye_color']) : null,
      hairColor: json['hair_color'] != null ? Color.fromJson(json['hair_color']) : null,
      resumePath: json['resume_path'],
      isAvailable: json['is_available'],
      skill: json['skill'] != null ? Skill.fromJson(json['skill']) : null,
    );
  }
}

class Color {
  final int id;
  final String name;

  Color({
    required this.id,
    required this.name,
  });

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
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