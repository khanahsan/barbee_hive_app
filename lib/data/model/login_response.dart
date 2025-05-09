/*
class LoginResponse {
  final bool status;
  final String message;
  final User user;
  final String token;

  LoginResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      user: User.fromJson(json['data']['user']),
      token: json['data']['token'] ?? '',
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
  final Employee employee;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.employee,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      role: json['role'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      employee: Employee.fromJson(json['employee']),
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
}*/


class LoginResponse {
  final bool status;
  final String message;
  final User user;
  final String token;

  LoginResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      user: User.fromJson(json['data']['user']),
      token: json['data']['token'] ?? '',
    );
  }
}

class User {
  final int id;
  final String email;
  final int role; // 3 for Employee, 2 for Employer
  final bool isVerified;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final Employee? employee; // Nullable, present for Employees
  final Employer? employer; // Nullable, present for Employers

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.employee, // Nullable
    this.employer, // Nullable
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      role: json['role'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
      employer: json['employer'] != null ? Employer.fromJson(json['employer']) : null,
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