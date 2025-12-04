/*
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
    return DashboardResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] is Map
              ? DashboardData.fromJson(json['data'])
              : DashboardData(employees: [], employers: []),
    );
  }
}

class DashboardData {
  final List<User> employees;
  final List<User> employers;

  DashboardData({required this.employees, required this.employers});

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      employees:
          json['employees'] is List
              ? (json['employees'] as List)
                  .map(
                    (e) =>
                        e != null
                            ? User.fromJson(Map<String, dynamic>.from(e as Map))
                            : User.empty(),
                  )
                  .toList()
              : [],
      employers:
          json['employers'] is List
              ? (json['employers'] as List)
                  .map(
                    (e) =>
                        e != null
                            ? User.fromJson(Map<String, dynamic>.from(e as Map))
                            : User.empty(),
                  )
                  .toList()
              : [],
    );
  }
}

class User {
  final int id;
  final String uid;
  final String email;
  final int role;
  final bool isVerified;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final Employee? employee;
  final Employer? employer;
  final String? profileImage;
  final Subscription? subscription;

  User({
    required this.id,
    required this.uid,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.employee,
    this.employer,
    this.profileImage,
    this.subscription,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      profileImage:
          json['profile_image'] is String ? json['profile_image'] : null,
      employee:
          json['employee'] is Map ? Employee.fromJson(json['employee']) : null,
      employer:
          json['employer'] is Map ? Employer.fromJson(json['employer']) : null,
      subscription:
          json['subscription'] is Map
              ? Subscription.fromJson(json['subscription'])
              : null,
    );
  }

  /// Empty user for safe fallback
  factory User.empty() => User(
    id: 0,
    uid: '',
    email: '',
    role: 0,
    isVerified: false,
    isActive: false,
    createdAt: '',
    updatedAt: '',
  );
}

class Employee {
  final String name;
  final String initials;
  final String? experienceYears;
  final Country? country;
  final State? state;
  final String? city;
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
    required this.initials,
    this.experienceYears,
    this.country,
    this.state,
    this.city,
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
      initials: json['initials'] ?? '',
      experienceYears:
          json['experience_years'] is String ? json['experience_years'] : null,
      country:
          json['country'] is Map ? Country.fromJson(json['country']) : null,
      state: json['state'] is Map ? State.fromJson(json['state']) : null,
      city: json['city'] is String ? json['city'] : null,
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      height: json['height'] ?? 0,
      eyeColor:
          json['eye_color'] is Map
              ? EyeColor.fromJson(json['eye_color'])
              : null,
      hairColor:
          json['hair_color'] is Map
              ? HairColor.fromJson(json['hair_color'])
              : null,
      resumePath: json['resume_path'] is String ? json['resume_path'] : null,
      isAvailable: json['is_available'] ?? false,
      skill: json['skill'] is Map ? Skill.fromJson(json['skill']) : null,
    );
  }
}

class Employer {
  final String businessName;
  final String? country;
  final String? state;
  final String? city;
  final PositionSeeking? positionSeeking;

  Employer({
    required this.businessName,
    this.country,
    this.state,
    this.city,
    this.positionSeeking,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      businessName: json['business_name'] ?? '',
      country: json['country'] is String ? json['country'] : null,
      state: json['state'] is String ? json['state'] : null,
      city: json['city'] is String ? json['city'] : null,
      positionSeeking:
          json['position_seeking'] is Map
              ? PositionSeeking.fromJson(json['position_seeking'])
              : null,
    );
  }
}

class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class State {
  final int id;
  final String name;

  State({required this.id, required this.name});

  factory State.fromJson(Map<String, dynamic> json) {
    return State(id: json['id'] ?? 0, name: json['name'] ?? '');
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

class PositionSeeking {
  final int id;
  final String name;

  PositionSeeking({required this.id, required this.name});

  factory PositionSeeking.fromJson(Map<String, dynamic> json) {
    return PositionSeeking(id: json['id'] ?? 0, name: json['name'] ?? '');
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
*/


// Corrected Dart models for the Dashboard JSON response
// Generated to match the provided API response exactly.

class DashboardResponse {
  final bool status;
  final String message;
  final DashboardData data;

  DashboardResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) => DashboardResponse(
    status: json['status'] ?? false,
    message: json['message'] ?? '',
    data: json['data'] is Map
        ? DashboardData.fromJson(Map<String, dynamic>.from(json['data']))
        : DashboardData(employees: [], employers: []),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

class DashboardData {
  final List<User> employees;
  final List<User> employers;

  DashboardData({required this.employees, required this.employers});

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    employees: json['employees'] is List
        ? (json['employees'] as List)
        .map((e) => User.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
        : [],
    employers: json['employers'] is List
        ? (json['employers'] as List)
        .map((e) => User.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    'employees': employees.map((e) => e.toJson()).toList(),
    'employers': employers.map((e) => e.toJson()).toList(),
  };
}

class User {
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
  final Employee? employee;
  final Employer? employer;

  User({
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
    this.employee,
    this.employer,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] ?? 0,
    uid: json['uid'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? 0,
    isVerified: json['is_verified'] ?? false,
    isActive: json['is_active'] ?? false,
    profileImage: json['profile_image'] is String ? json['profile_image'] : null,
    coverPhoto: json['cover_photo'] is String ? json['cover_photo'] : null,
    subscription: json['subscription'] is Map
        ? Subscription.fromJson(Map<String, dynamic>.from(json['subscription']))
        : null,
    createdAt: json['created_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
    employee: json['employee'] is Map
        ? Employee.fromJson(Map<String, dynamic>.from(json['employee']))
        : null,
    employer: json['employer'] is Map
        ? Employer.fromJson(Map<String, dynamic>.from(json['employer']))
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'email': email,
    'role': role,
    'is_verified': isVerified,
    'is_active': isActive,
    'profile_image': profileImage,
    'cover_photo': coverPhoto,
    'subscription': subscription?.toJson(),
    'created_at': createdAt,
    'updated_at': updatedAt,
    'employee': employee?.toJson(),
    'employer': employer?.toJson(),
  };
}

class Employee {
  final String name;
  final String initials;
  final String? experienceYears;
  final Country? country;
  final State? state;
  final String? city;
  final String dob;
  final String gender;
  final int height;
  final EyeColor? eyeColor;
  final HairColor? hairColor;
  final String? resumePath;
  final bool isAvailable;
  final List<Skill> skills;

  Employee({
    required this.name,
    required this.initials,
    this.experienceYears,
    this.country,
    this.state,
    this.city,
    required this.dob,
    required this.gender,
    required this.height,
    this.eyeColor,
    this.hairColor,
    this.resumePath,
    required this.isAvailable,
    required this.skills,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    name: json['name'] ?? '',
    initials: json['initials'] ?? '',
    experienceYears: json['experience_years'] is String ? json['experience_years'] : null,
    country: json['country'] is Map ? Country.fromJson(Map<String, dynamic>.from(json['country'])) : null,
    state: json['state'] is Map ? State.fromJson(Map<String, dynamic>.from(json['state'])) : null,
    city: json['city'] is String ? json['city'] : null,
    dob: json['dob'] ?? '',
    gender: json['gender'] ?? '',
    height: json['height'] ?? 0,
    eyeColor: json['eye_color'] is Map ? EyeColor.fromJson(Map<String, dynamic>.from(json['eye_color'])) : null,
    hairColor: json['hair_color'] is Map ? HairColor.fromJson(Map<String, dynamic>.from(json['hair_color'])) : null,
    resumePath: json['resume_path'] is String ? json['resume_path'] : null,
    isAvailable: json['is_available'] ?? false,
    skills: json['skills'] is List
        ? (json['skills'] as List).map((e) => Skill.fromJson(Map<String, dynamic>.from(e as Map))).toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'initials': initials,
    'experience_years': experienceYears,
    'country': country?.toJson(),
    'state': state?.toJson(),
    'city': city,
    'dob': dob,
    'gender': gender,
    'height': height,
    'eye_color': eyeColor?.toJson(),
    'hair_color': hairColor?.toJson(),
    'resume_path': resumePath,
    'is_available': isAvailable,
    'skills': skills.map((s) => s.toJson()).toList(),
  };
}

class Employer {
  final String businessName;
  final String? initials;
  final Country? country;
  final State? state;
  final String? city;
  final List<Skill> skills;

  Employer({
    required this.businessName,
    this.initials,
    this.country,
    this.state,
    this.city,
    required this.skills,
  });

  factory Employer.fromJson(Map<String, dynamic> json) => Employer(
    businessName: json['business_name'] ?? '',
    initials: json['initials'] ?? null,
    country: json['country'] is Map ? Country.fromJson(Map<String, dynamic>.from(json['country'])) : null,
    state: json['state'] is Map ? State.fromJson(Map<String, dynamic>.from(json['state'])) : null,
    city: json['city'] is String ? json['city'] : null,
    skills: json['skills'] is List
        ? (json['skills'] as List).map((e) => Skill.fromJson(Map<String, dynamic>.from(e as Map))).toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    'business_name': businessName,
    'initials': initials,
    'country': country?.toJson(),
    'state': state?.toJson(),
    'city': city,
    'skills': skills.map((s) => s.toJson()).toList(),
  };
}

class Country {
  final int id;
  final String name;
  final String? code;

  Country({required this.id, required this.name, this.code});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    code: json['code'] is String ? json['code'] : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
  };
}

class State {
  final int id;
  final int? countryId;
  final String name;
  final String? code;

  State({required this.id, this.countryId, required this.name, this.code});

  factory State.fromJson(Map<String, dynamic> json) => State(
    id: json['id'] ?? 0,
    countryId: json['country_id'] is int ? json['country_id'] : (json['country_id'] is String ? int.tryParse(json['country_id']) : null),
    name: json['name'] ?? '',
    code: json['code'] is String ? json['code'] : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'country_id': countryId,
    'name': name,
    'code': code,
  };
}

class EyeColor {
  final int id;
  final String name;

  EyeColor({required this.id, required this.name});

  factory EyeColor.fromJson(Map<String, dynamic> json) => EyeColor(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class HairColor {
  final int id;
  final String name;

  HairColor({required this.id, required this.name});

  factory HairColor.fromJson(Map<String, dynamic> json) => HairColor(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Skill {
  final int id;
  final String name;

  Skill({required this.id, required this.name});

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
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

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'plan_id': planId,
    'plan_name': planName,
    'plan_type': planType,
    'start_date': startDate,
    'end_date': endDate,
    'status': status,
    'payment_status': paymentStatus,
    'amount_paid': amountPaid,
    'is_active': isActive,
    'is_expired': isExpired,
  };
}
