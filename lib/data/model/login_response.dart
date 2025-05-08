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
      status: json['status'],
      message: json['message'],
      user: User.fromJson(json['data']['user']),
      token: json['data']['token'],
    );
  }
}

class User {
  final int id;
  final String? username;
  final String email;
  final String role;
  final bool isVerified;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final Employer employer;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.employer,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      isVerified: json['is_verified'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      employer: Employer.fromJson(json['employer']),
    );
  }
}

class Employer {
  final String businessName;
  final String country;
  final String state;
  final String city;
  final String? positionSeeking;

  Employer({
    required this.businessName,
    required this.country,
    required this.state,
    required this.city,
    this.positionSeeking,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      businessName: json['business_name'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      positionSeeking: json['position_seeking'],
    );
  }
}
