class JobPostResponse {
  final bool status;
  final String message;
  final JobData data;

  JobPostResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobPostResponse.fromJson(Map<String, dynamic> json) {
    return JobPostResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: JobData.fromJson(json['data']),
    );
  }
}

class JobData {
  final int id;
  final String title;
  final String description;
  final String experienceLevel;
  final SalaryRange salaryRange;
  final String jobType;
  final String country;
  final String state;
  final String city;
  final String recruiterName;
  final String? image;
  final bool isActive;
  final String expiresAt;
  final int remainingHours;
  final Employer employer;
  final String createdAt;
  final String updatedAt;

  JobData({
    required this.id,
    required this.title,
    required this.description,
    required this.experienceLevel,
    required this.salaryRange,
    required this.jobType,
    required this.country,
    required this.state,
    required this.city,
    required this.recruiterName,
    this.image,
    required this.isActive,
    required this.expiresAt,
    required this.remainingHours,
    required this.employer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      experienceLevel: json['experience_level'] ?? '',
      salaryRange: SalaryRange.fromJson(json['salary_range']),
      jobType: json['job_type'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      recruiterName: json['recruiter_name'] ?? '',
      image: json['image'],
      isActive: json['is_active'] ?? false,
      expiresAt: json['expires_at'] ?? '',
      remainingHours: json['remaining_hours'] ?? 0,
      employer: Employer.fromJson(json['employer']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class SalaryRange {
  final String min;
  final String max;

  SalaryRange({
    required this.min,
    required this.max,
  });

  factory SalaryRange.fromJson(Map<String, dynamic> json) {
    return SalaryRange(
      min: json['min'] ?? '0.00',
      max: json['max'] ?? '0.00',
    );
  }
}

class Employer {
  final int id;
  final String businessName;
  final String? businessType;
  final String country;
  final String state;
  final String city;
  final String? profileImage;

  Employer({
    required this.id,
    required this.businessName,
    this.businessType,
    required this.country,
    required this.state,
    required this.city,
    this.profileImage,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      id: json['id'] ?? 0,
      businessName: json['business_name'] ?? '',
      businessType: json['business_type'],
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      profileImage: json['profile_image'],
    );
  }
}