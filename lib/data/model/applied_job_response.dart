class AppliedJobsResponse {
  final bool status;
  final String message;
  final List<JobData> data;

  AppliedJobsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AppliedJobsResponse.fromJson(Map<String, dynamic> json) {
    return AppliedJobsResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => JobData.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
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
  final Skill skills;

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
    required this.image,
    required this.isActive,
    required this.expiresAt,
    required this.remainingHours,
    required this.employer,
    required this.createdAt,
    required this.updatedAt,
    required this.skills,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      experienceLevel: json['experience_level'] ?? '',
      salaryRange: SalaryRange.fromJson(json['salary_range'] ?? {}),
      jobType: json['job_type'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      recruiterName: json['recruiter_name'] ?? '',
      image: json['image'],
      isActive: json['is_active'] ?? false,
      expiresAt: json['expires_at'] ?? '',
      remainingHours: json['remaining_hours'] ?? 0,
      employer: Employer.fromJson(json['employer'] ?? {}),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      skills: Skill.fromJson(json['skills'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'experience_level': experienceLevel,
      'salary_range': salaryRange.toJson(),
      'job_type': jobType,
      'country': country,
      'state': state,
      'city': city,
      'recruiter_name': recruiterName,
      'image': image,
      'is_active': isActive,
      'expires_at': expiresAt,
      'remaining_hours': remainingHours,
      'employer': employer.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'skills': skills.toJson(),
    };
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
      min: json['min'] ?? '',
      max: json['max'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_name': businessName,
      'business_type': businessType,
      'country': country,
      'state': state,
      'city': city,
      'profile_image': profileImage,
    };
  }
}

class Skill {
  final int id;
  final String name;
  final int isRequired;

  Skill({
    required this.id,
    required this.name,
    required this.isRequired,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isRequired: json['is_required'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_required': isRequired,
    };
  }
}
