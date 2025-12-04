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
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: UserProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserProfileData {
  final int id;
  final String uid;
  final String email;
  final int role;
  final bool isVerified;
  final bool isActive;
  final String? profileImage;
  final String? coverPhoto;
  final Subscription? subscription;
  final String createdAt;
  final String updatedAt;
  final Employer? employer;
  final Employee? employee;

  UserProfileData({
    required this.id,
    required this.uid,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    this.profileImage,
    this.coverPhoto,
    this.subscription,
    required this.createdAt,
    required this.updatedAt,
    this.employer,
    this.employee,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    final role = json['role'] ?? 0;
    return UserProfileData(
      id: json['id'] ?? 0,
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      role: role,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? false,
      profileImage: json['profile_image'],
      coverPhoto: json['cover_photo'],
      subscription:
          json['subscription'] != null
              ? Subscription.fromJson(json['subscription'])
              : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      employer:
          role == 2 && json['employer'] != null
              ? Employer.fromJson(json['employer'])
              : null,
      employee:
          role == 3 && json['employee'] != null
              ? Employee.fromJson(json['employee'])
              : null,
    );
  }
}

class Subscription {
  final int id;
  final int planId;
  final String planName;
  final String planType;
  final String startDate;
  final String endDate;
  final String status;
  final String paymentStatus;
  final int amountPaid;
  final bool isActive;
  final bool isExpired;

  Subscription({
    required this.id,
    required this.planId,
    required this.planName,
    required this.planType,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.paymentStatus,
    required this.amountPaid,
    required this.isActive,
    required this.isExpired,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] ?? 0,
      planId: json['plan_id'] ?? 0,
      planName: json['plan_name'] ?? '',
      planType: json['plan_type'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      amountPaid: json['amount_paid'] ?? 0,
      isActive: json['is_active'] ?? false,
      isExpired: json['is_expired'] ?? false,
    );
  }
}

class Employee {
  final String name;
  final String initials;
  final String? experienceYears;
  final ProfileCountry? country;
  final ProfileState? state;
  final String city;
  final String dob;
  final String? gender;
  final int? height;
  final EyeColor? eyeColor;
  final HairColor? hairColor;
  final bool isAvailable;
  final List<Skill> skills;
  final String? resumePath;

  Employee({
    required this.name,
    required this.initials,
    this.experienceYears,
    this.country,
    this.state,
    required this.city,
    required this.dob,
    this.gender,
    this.height,
    this.eyeColor,
    this.hairColor,
    required this.isAvailable,
    required this.skills,
    this.resumePath,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'] ?? '',
      initials: json['initials'] ?? '',
      experienceYears: json['experience_years']?.toString(),
      country:
          json['country'] != null
              ? ProfileCountry.fromJson(json['country'])
              : null,
      state:
          json['state'] != null ? ProfileState.fromJson(json['state']) : null,
      city: json['city'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'],
      height: json['height'],
      eyeColor:
          json['eye_color'] != null
              ? EyeColor.fromJson(json['eye_color'])
              : null,
      hairColor:
          json['hair_color'] != null
              ? HairColor.fromJson(json['hair_color'])
              : null,
      isAvailable: json['is_available'] ?? false,
      skills:
          json['skills'] != null
              ? List<Skill>.from(json['skills'].map((x) => Skill.fromJson(x)))
              : [],
      resumePath: json['resume_path'],
    );
  }
}

class Employer {
  final String businessName;
  final String initials;
  final ProfileCountry? country;
  final ProfileState? state;
  final String? city;
  final List<Skill> skills;

  Employer({
    required this.businessName,
    required this.initials,
    this.country,
    this.state,
    this.city,
    required this.skills,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      businessName: json['business_name'] ?? '',
      initials: json['initials'] ?? '',
      country:
          json['country'] != null
              ? ProfileCountry.fromJson(json['country'])
              : null,
      state:
          json['state'] != null ? ProfileState.fromJson(json['state']) : null,
      city: json['city'],
      skills:
      json['skills'] != null
          ? List<Skill>.from(json['skills'].map((x) => Skill.fromJson(x)))
          : [],
    );
  }
}

class ProfileCountry {
  final int id;
  final String name;
  final String code;

  ProfileCountry({required this.id, required this.name, required this.code});

  factory ProfileCountry.fromJson(Map<String, dynamic> json) {
    return ProfileCountry(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class ProfileState {
  final int id;
  final int? countryId;
  final String name;
  final String code;
  final String? status;

  ProfileState({
    required this.id,
    this.countryId,
    required this.name,
    required this.code,
    this.status,
  });

  factory ProfileState.fromJson(Map<String, dynamic> json) {
    return ProfileState(
      id: json['id'] ?? 0,
      countryId: json['country_id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      status: json['status'],
    );
  }
}

class EyeColor {
  final int id;
  final String name;

  EyeColor({required this.id, required this.name});

  factory EyeColor.fromJson(Map<String, dynamic> json) {
    return EyeColor(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class HairColor {
  final int id;
  final String name;

  HairColor({required this.id, required this.name});

  factory HairColor.fromJson(Map<String, dynamic> json) {
    return HairColor(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class Skill {
  final int id;
  final String name;

  Skill({required this.id, required this.name});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
