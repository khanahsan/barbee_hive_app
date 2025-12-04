/*
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
  final String? experienceYears;
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
      experienceYears: json['experience_years']?.toString(),
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
}*/


// ------------------------------------------------------------
// APPLICANT PROFILE RESPONSE MODEL
// ------------------------------------------------------------

class ApplicantProfileResponse {
  final bool status;
  final String message;
  final ApplicantProfileData data;

  ApplicantProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApplicantProfileResponse.fromJson(Map<String, dynamic> json) {
    return ApplicantProfileResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ApplicantProfileData.fromJson(json['data']),
    );
  }
}

// ------------------------------------------------------------
// PROFILE DATA
// ------------------------------------------------------------

class ApplicantProfileData {
  final int id;
  final String email;
  final int role;
  final bool isVerified;
  final bool isActive;
  final String? profileImage;
  final String? coverPhoto;
  final String createdAt;
  final String updatedAt;
  final ApplicantProfileEmployer? employer;
  final ApplicationProfileEmployee? employee;

  ApplicantProfileData({
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

  factory ApplicantProfileData.fromJson(Map<String, dynamic> json) {
    return ApplicantProfileData(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      role: json['role'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? false,
      profileImage: json['profile_image'],
      coverPhoto: json['cover_photo'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      employer: json['employer'] != null
          ? ApplicantProfileEmployer.fromJson(json['employer'])
          : null,
      employee: json['employee'] != null
          ? ApplicationProfileEmployee.fromJson(json['employee'])
          : null,
    );
  }
}

// ------------------------------------------------------------
// EMPLOYER MODEL
// ------------------------------------------------------------

class ApplicantProfileEmployer {
  final String businessName;
  final String initials;
  final ApplicationProfileCountry? country;
  final ApplicantProfileState? state;
  final String city;
  final List<ApplicantProfileSkill> skills;

  ApplicantProfileEmployer({
    required this.businessName,
    required this.initials,
    this.country,
    this.state,
    required this.city,
    required this.skills,
  });

  factory ApplicantProfileEmployer.fromJson(Map<String, dynamic> json) {
    return ApplicantProfileEmployer(
      businessName: json['business_name'] ?? '',
      initials: json['initials'] ?? '',
      country: json['country'] != null
          ? ApplicationProfileCountry.fromJson(json['country'])
          : null,
      state: json['state'] != null
          ? ApplicantProfileState.fromJson(json['state'])
          : null,
      city: json['city'] ?? '',
      skills: json['skills'] != null
          ? (json['skills'] as List)
          .map((e) => ApplicantProfileSkill.fromJson(e))
          .toList()
          : [],
    );
  }
}


// ------------------------------------------------------------
// EMPLOYEE MODEL
// ------------------------------------------------------------

class ApplicationProfileEmployee {
  final String? name;
  final String? initials;
  final String? experienceYears;
  final ApplicationProfileCountry? country;
  final ApplicantProfileState? state;
  final String? city;
  final String? dob;
  final String? gender;
  final int? height;
  final ApplicationProfileColor? eyeColor;
  final ApplicationProfileColor? hairColor;
  final String? resumePath;
  final bool? isAvailable;
  final List<ApplicantProfileSkill> skills;

  ApplicationProfileEmployee({
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
    required this.skills,
  });

  factory ApplicationProfileEmployee.fromJson(Map<String, dynamic> json) {
    return ApplicationProfileEmployee(
      name: json['name'],
      initials: json['initials'],
      experienceYears: json['experience_years']?.toString(),
      country: json['country'] != null
          ? ApplicationProfileCountry.fromJson(json['country'])
          : null,
      state: json['state'] != null
          ? ApplicantProfileState.fromJson(json['state'])
          : null,
      city: json['city'],
      dob: json['dob'],
      gender: json['gender'],
      height: json['height'],
      eyeColor: json['eye_color'] != null
          ? ApplicationProfileColor.fromJson(json['eye_color'])
          : null,
      hairColor: json['hair_color'] != null
          ? ApplicationProfileColor.fromJson(json['hair_color'])
          : null,
      resumePath: json['resume_path'],
      isAvailable: json['is_available'],
      skills: json['skills'] != null
          ? (json['skills'] as List)
          .map((e) => ApplicantProfileSkill.fromJson(e))
          .toList()
          : [],
    );
  }
}


// ------------------------------------------------------------
// COUNTRY MODEL
// ------------------------------------------------------------

class ApplicationProfileCountry {
  final int id;
  final String name;
  final String code;

  ApplicationProfileCountry({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ApplicationProfileCountry.fromJson(Map<String, dynamic> json) {
    return ApplicationProfileCountry(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

// ------------------------------------------------------------
// STATE MODEL
// ------------------------------------------------------------

class ApplicantProfileState {
  final int id;
  final int countryId;
  final String name;
  final String code;

  ApplicantProfileState({
    required this.id,
    required this.countryId,
    required this.name,
    required this.code,
  });

  factory ApplicantProfileState.fromJson(Map<String, dynamic> json) {
    return ApplicantProfileState(
      id: json['id'] ?? 0,
      countryId: json['country_id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

// ------------------------------------------------------------
// COLOR MODEL ( renamed to avoid Flutter Color conflict )
// ------------------------------------------------------------

class ApplicationProfileColor {
  final int id;
  final String name;

  ApplicationProfileColor({
    required this.id,
    required this.name,
  });

  factory ApplicationProfileColor.fromJson(Map<String, dynamic> json) {
    return ApplicationProfileColor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

// ------------------------------------------------------------
// SKILL MODEL
// ------------------------------------------------------------

class ApplicantProfileSkill {
  final int id;
  final String name;

  ApplicantProfileSkill({
    required this.id,
    required this.name,
  });

  factory ApplicantProfileSkill.fromJson(Map<String, dynamic> json) {
    return ApplicantProfileSkill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
