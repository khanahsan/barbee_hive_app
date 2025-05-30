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
  final Employer? employer;
  final Employee? employee;

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
    this.employer,
    this.employee,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    final role = json['role'];

    return UserProfileData(
      id: json['id'],
      email: json['email'],
      role: role,
      isVerified: json['is_verified'],
      isActive: json['is_active'],
      profileImage: json['profile_image'],
      coverPhoto: json['cover_photo'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      employer: role == 2 ? Employer.fromJson(json['employer']) : null,
      employee: role == 3 ? Employee.fromJson(json['employee']) : null,
    );
  }
}


// class Employee {
//   final String name;
//   final String initials;
//   final String experienceYears;
//   final String country;
//   final String state;
//   final String city;
//   final String dob;
//   final String gender;
//   final int height;
//   final EyeColor eyeColor;
//   final HairColor hairColor;
//   final bool isAvailable;
//   final Skill skill;
//   final String? resumePath;
//
//   Employee({
//     required this.name,
//     required this.initials,
//     required this.experienceYears,
//     required this.country,
//     required this.state,
//     required this.city,
//     required this.dob,
//     required this.gender,
//     required this.height,
//     required this.eyeColor,
//     required this.hairColor,
//     required this.isAvailable,
//     required this.skill,
//     this.resumePath,
//   });
//
//   factory Employee.fromJson(Map<String, dynamic> json) {
//     return Employee(
//       name: json['name'],
//       initials: json['initials'],
//       experienceYears: json['experience_years'],
//       country: json['country'],
//       state: json['state'],
//       city: json['city'],
//       dob: json['dob'],
//       gender: json['gender'],
//       height: json['height'],
//       eyeColor: EyeColor.fromJson(json['eye_color']),
//       hairColor: HairColor.fromJson(json['hair_color']),
//       isAvailable: json['is_available'],
//       skill: Skill.fromJson(json['skill']),
//       resumePath: json['resume_path'],
//     );
//   }
// }

class Employee {
  final String name;
  final String initials;
  final String experienceYears;
  final String country;
  final String state;
  final String city;
  final String dob;
  final String? gender;
  final int? height;
  final EyeColor? eyeColor;
  final HairColor? hairColor;
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
    this.gender,
    this.height,
    this.eyeColor,
    this.hairColor,
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
      eyeColor: json['eye_color'] != null ? EyeColor.fromJson(json['eye_color']) : null,
      hairColor: json['hair_color'] != null ? HairColor.fromJson(json['hair_color']) : null,
      isAvailable: json['is_available'],
      skill: Skill.fromJson(json['skill']),
      resumePath: json['resume_path'],
    );
  }
}


class Employer {
  final String businessName;
  final String initials;
  final String country;
  final String state;
  final String city;
  final Skill skill;

  Employer({
    required this.businessName,
    required this.initials,
    required this.country,
    required this.state,
    required this.city,
    required this.skill,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      businessName: json['business_name'],
      initials: json['initials'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      skill: Skill.fromJson(json['skill']),
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

  Skill({required this.id, required this.name});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
    );
  }
}
