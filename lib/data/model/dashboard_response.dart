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
  final int isAvailable;

  Employee({
    required this.name,
    required this.experienceYears,
    required this.country,
    required this.state,
    required this.city,
    required this.dob,
    required this.isAvailable,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'] ?? '',
      experienceYears: json['experience_years'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      dob: json['dob'] ?? '',
      isAvailable: json['is_available'] ?? 0,
    );
  }
}

class Employer {
  final String businessName;
  final String country;
  final String state;
  final String city;
  final String positionSeeking;

  Employer({
    required this.businessName,
    required this.country,
    required this.state,
    required this.city,
    required this.positionSeeking,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      businessName: json['business_name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      positionSeeking: json['position_seeking'] ?? '',
    );
  }
}