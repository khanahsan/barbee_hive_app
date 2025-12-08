/*
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
*/


class AppliedJobsResponse {
  final bool status;
  final String message;
  final List<AppliedJobData> data;

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
          ?.map((item) => AppliedJobData.fromJson(item))
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

class AppliedJobData {
  final int id;
  final String title;
  final String description;
  final String experienceLevel;
  final AppliedJobSalaryRange salaryRange;
  final AppliedJobType jobType;
  final AppliedJobCountry country;
  final AppliedJobState state;
  final String city;
  final String recruiterName;
  final String? image;
  final bool isActive;
  final int isApplied; // new field
  final String expiresAt;
  final int remainingHours;
  final AppliedJobEmployer employer;
  final String createdAt;
  final String updatedAt;
  final AppliedJobSkill skills;

  AppliedJobData({
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
    required this.isApplied,
    required this.expiresAt,
    required this.remainingHours,
    required this.employer,
    required this.createdAt,
    required this.updatedAt,
    required this.skills,
  });

  factory AppliedJobData.fromJson(Map<String, dynamic> json) {
    return AppliedJobData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      experienceLevel: json['experience_level'] ?? '',
      salaryRange: AppliedJobSalaryRange.fromJson(json['salary_range'] ?? {}),
      jobType: AppliedJobType.fromJson(json['job_type'] ?? {}),
      country: AppliedJobCountry.fromJson(json['country'] ?? {}),
      state: AppliedJobState.fromJson(json['state'] ?? {}),
      city: json['city'] ?? '',
      recruiterName: json['recruiter_name'] ?? '',
      image: json['image'],
      isActive: json['is_active'] ?? false,
      isApplied: json['is_applied'] ?? 0,
      expiresAt: json['expires_at'] ?? '',
      remainingHours: json['remaining_hours'] ?? 0,
      employer: AppliedJobEmployer.fromJson(json['employer'] ?? {}),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      skills: AppliedJobSkill.fromJson(json['skills'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'experience_level': experienceLevel,
      'salary_range': salaryRange.toJson(),
      'job_type': jobType.toJson(),
      'country': country.toJson(),
      'state': state.toJson(),
      'city': city,
      'recruiter_name': recruiterName,
      'image': image,
      'is_active': isActive,
      'is_applied': isApplied,
      'expires_at': expiresAt,
      'remaining_hours': remainingHours,
      'employer': employer.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'skills': skills.toJson(),
    };
  }
}

class AppliedJobSalaryRange {
  final String min;
  final String max;
  final AppliedJobSalaryType type;

  AppliedJobSalaryRange({
    required this.min,
    required this.max,
    required this.type,
  });

  factory AppliedJobSalaryRange.fromJson(Map<String, dynamic> json) {
    return AppliedJobSalaryRange(
      min: json['min'] ?? '',
      max: json['max'] ?? '',
      type: AppliedJobSalaryType.fromJson(json['type'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
      'type': type.toJson(),
    };
  }
}

class AppliedJobSalaryType {
  final String id;
  final String name;

  AppliedJobSalaryType({required this.id, required this.name});

  factory AppliedJobSalaryType.fromJson(Map<String, dynamic> json) {
    return AppliedJobSalaryType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class AppliedJobType {
  final String id;
  final String name;

  AppliedJobType({required this.id, required this.name});

  factory AppliedJobType.fromJson(Map<String, dynamic> json) {
    return AppliedJobType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class AppliedJobCountry {
  final int id;
  final String name;
  final String code;

  AppliedJobCountry({required this.id, required this.name, required this.code});

  factory AppliedJobCountry.fromJson(Map<String, dynamic> json) {
    return AppliedJobCountry(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'code': code};
}

class AppliedJobState {
  final int id;
  final int countryId;
  final String name;
  final String code;

  AppliedJobState({
    required this.id,
    required this.countryId,
    required this.name,
    required this.code,
  });

  factory AppliedJobState.fromJson(Map<String, dynamic> json) {
    return AppliedJobState(
      id: json['id'] ?? 0,
      countryId: json['country_id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'country_id': countryId,
    'name': name,
    'code': code,
  };
}

class AppliedJobEmployer {
  final int id;
  final String businessName;
  final String? businessType;
  final AppliedJobCountry country;
  final AppliedJobState state;
  final String city;
  final String? profileImage;

  AppliedJobEmployer({
    required this.id,
    required this.businessName,
    this.businessType,
    required this.country,
    required this.state,
    required this.city,
    this.profileImage,
  });

  factory AppliedJobEmployer.fromJson(Map<String, dynamic> json) {
    return AppliedJobEmployer(
      id: json['id'] ?? 0,
      businessName: json['business_name'] ?? '',
      businessType: json['business_type'],
      country: AppliedJobCountry.fromJson(json['country'] ?? {}),
      state: AppliedJobState.fromJson(json['state'] ?? {}),
      city: json['city'] ?? '',
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_name': businessName,
      'business_type': businessType,
      'country': country.toJson(),
      'state': state.toJson(),
      'city': city,
      'profile_image': profileImage,
    };
  }
}

class AppliedJobSkill {
  final int id;
  final String name;
  final int isRequired;

  AppliedJobSkill({
    required this.id,
    required this.name,
    required this.isRequired,
  });

  factory AppliedJobSkill.fromJson(Map<String, dynamic> json) {
    return AppliedJobSkill(
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
