class JobListResponse {
  final bool status;
  final String message;
  final List<JobData> data;
  final Meta meta;

  JobListResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory JobListResponse.fromJson(Map<String, dynamic> json) {
    return JobListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => JobData.fromJson(item))
              .toList() ??
          [],
      meta: Meta.fromJson(json['meta']),
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
  final Skill? skills;
  //final List<Skill>? skills;

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
    this.skills,
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
      skills:
          json['skills'] != null ? Skill.fromJson(json['skills']) : null, // ✅
      // skills:
      //     (json['skills'] as List<dynamic>?)
      //         ?.map((item) => Skill.fromJson(item))
      //         .toList(),
    );
  }
}

class SalaryRange {
  final String min;
  final String max;

  SalaryRange({required this.min, required this.max});

  factory SalaryRange.fromJson(Map<String, dynamic> json) {
    return SalaryRange(min: json['min'] ?? '0.00', max: json['max'] ?? '0.00');
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

class Skill {
  final int id;
  final String name;
  final int isRequired;

  Skill({required this.id, required this.name, required this.isRequired});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isRequired: json['is_required'] ?? 0,
    );
  }
}

class Meta {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int from;
  final int to;

  Meta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.from,
    required this.to,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 10000,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      from: json['from'] ?? 1,
      to: json['to'] ?? 0,
    );
  }
}
