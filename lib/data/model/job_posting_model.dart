/*



// ------------------------------------------------------------
// JOB POST RESPONSE MODEL
// ------------------------------------------------------------

class JobPostResponse {
  final bool status;
  final String message;
  final JobPostData data;

  JobPostResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobPostResponse.fromJson(Map<String, dynamic> json) {
    return JobPostResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: JobPostData.fromJson(json['data']),
    );
  }
}

// ------------------------------------------------------------
// JOB DATA
// ------------------------------------------------------------

class JobPostData {
  final int id;
  final String title;
  final String description;
  final String experienceLevel;
  final JobPostSalaryRange salaryRange;
  final JobPostJobType jobType;
  final JobPostCountry country;
  final JobPostState state;
  final String city;
  final String recruiterName;
  final String? image;
  final bool isActive;
  final String expiresAt;
  final int remainingHours;
  final JobPostEmployer employer;
  final String createdAt;
  final String updatedAt;
  final JobPostSkill? skills;

  JobPostData({
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

  factory JobPostData.fromJson(Map<String, dynamic> json) {
    return JobPostData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      experienceLevel: json['experience_level'] ?? '',
      salaryRange: JobPostSalaryRange.fromJson(json['salary_range']),
      jobType: JobPostJobType.fromJson(json['job_type']),
      country: JobPostCountry.fromJson(json['country']),
      state: JobPostState.fromJson(json['state']),
      city: json['city'] ?? '',
      recruiterName: json['recruiter_name'] ?? '',
      image: json['image'],
      isActive: json['is_active'] ?? false,
      expiresAt: json['expires_at'] ?? '',
      remainingHours: json['remaining_hours'] ?? 0,
      employer: JobPostEmployer.fromJson(json['employer']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      skills: json['skills'] != null ? JobPostSkill.fromJson(json['skills']) : null,
    );
  }
}

// ------------------------------------------------------------
// SALARY RANGE MODEL
// ------------------------------------------------------------

class JobPostSalaryRange {
  final String min;
  final String max;
  final String type;

  JobPostSalaryRange({
    required this.min,
    required this.max,
    required this.type,
  });

  factory JobPostSalaryRange.fromJson(Map<String, dynamic> json) {
    return JobPostSalaryRange(
      min: json['min'] ?? '0.00',
      max: json['max'] ?? '0.00',
      type: json['type'] ?? '',
    );
  }
}

// ------------------------------------------------------------
// COUNTRY MODEL
// ------------------------------------------------------------

class JobPostCountry {
  final int id;
  final String name;
  final String code;

  JobPostCountry({
    required this.id,
    required this.name,
    required this.code,
  });

  factory JobPostCountry.fromJson(Map<String, dynamic> json) {
    return JobPostCountry(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

// ------------------------------------------------------------
// STATE MODEL
// ------------------------------------------------------------

class JobPostState {
  final int id;
  final int countryId;
  final String name;
  final String code;

  JobPostState({
    required this.id,
    required this.countryId,
    required this.name,
    required this.code,
  });

  factory JobPostState.fromJson(Map<String, dynamic> json) {
    return JobPostState(
      id: json['id'] ?? 0,
      countryId: json['country_id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

// ------------------------------------------------------------
// EMPLOYER MODEL
// ------------------------------------------------------------

class JobPostEmployer {
  final int id;
  final String businessName;
  final String? businessType;
  final JobPostCountry country;
  final JobPostState state;
  final String city;
  final String? profileImage;

  JobPostEmployer({
    required this.id,
    required this.businessName,
    this.businessType,
    required this.country,
    required this.state,
    required this.city,
    this.profileImage,
  });

  factory JobPostEmployer.fromJson(Map<String, dynamic> json) {
    return JobPostEmployer(
      id: json['id'] ?? 0,
      businessName: json['business_name'] ?? '',
      businessType: json['business_type'],
      country: JobPostCountry.fromJson(json['country']),
      state: JobPostState.fromJson(json['state']),
      city: json['city'] ?? '',
      profileImage: json['profile_image'],
    );
  }
}

// ------------------------------------------------------------
// SKILLS MODEL
// ------------------------------------------------------------

class JobPostSkill {
  final int id;
  final String name;
  final int isRequired;

  JobPostSkill({
    required this.id,
    required this.name,
    required this.isRequired,
  });

  factory JobPostSkill.fromJson(Map<String, dynamic> json) {
    return JobPostSkill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isRequired: json['is_required'] ?? 0,
    );
  }
}

class JobPostJobType {
  final String id;
  final String name;

  JobPostJobType({
    required this.id,
    required this.name,
  });

  factory JobPostJobType.fromJson(Map<String, dynamic> json) {
    return JobPostJobType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}


*/


// ------------------------------------------------------------
// JOB POST RESPONSE MODEL
// ------------------------------------------------------------
class JobPostResponse {
  final bool status;
  final String message;
  final JobPostData data;

  JobPostResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobPostResponse.fromJson(Map<String, dynamic> json) {
    return JobPostResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: JobPostData.fromJson(json['data']),
    );
  }
}

// ------------------------------------------------------------
// JOB DATA
// ------------------------------------------------------------
class JobPostData {
  final int id;
  final String title;
  final String description;
  final String experienceLevel;
  final JobPostSalaryRange salaryRange;
  final JobPostJobType jobType;
  final JobPostCountry country;
  final JobPostState state;
  final String city;
  final String recruiterName;
  final String? image;
  final bool isActive;
  final String expiresAt;
  final int remainingHours;
  final JobPostEmployer employer;
  final String createdAt;
  final String updatedAt;
  final List<JobPostSkill> skills;

  JobPostData({
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
    required this.skills,
  });

  factory JobPostData.fromJson(Map<String, dynamic> json) {
    return JobPostData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      experienceLevel: json['experience_level'] ?? '',
      salaryRange: JobPostSalaryRange.fromJson(json['salary_range']),
      jobType: JobPostJobType.fromJson(json['job_type']),
      country: JobPostCountry.fromJson(json['country']),
      state: JobPostState.fromJson(json['state']),
      city: json['city'] ?? '',
      recruiterName: json['recruiter_name'] ?? '',
      image: json['image'],
      isActive: json['is_active'] ?? false,
      expiresAt: json['expires_at'] ?? '',
      remainingHours: json['remaining_hours'] ?? 0,
      employer: JobPostEmployer.fromJson(json['employer']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      skills: json['skills'] != null
          ? (json['skills'] is List
          ? List<JobPostSkill>.from(
          json['skills'].map((x) => JobPostSkill.fromJson(x)))
          : [JobPostSkill.fromJson(json['skills'])])
          : [],
    );
  }
}

// ------------------------------------------------------------
// SALARY RANGE MODEL
// ------------------------------------------------------------
class JobPostSalaryRange {
  final String min;
  final String max;
  final SalaryType type;

  JobPostSalaryRange({
    required this.min,
    required this.max,
    required this.type,
  });

  factory JobPostSalaryRange.fromJson(Map<String, dynamic> json) {
    return JobPostSalaryRange(
      min: json['min'] ?? '0.00',
      max: json['max'] ?? '0.00',
      type: SalaryType.fromJson(json['type']),
    );
  }
}

class SalaryType {
  final String id;
  final String name;

  SalaryType({
    required this.id,
    required this.name,
  });

  factory SalaryType.fromJson(Map<String, dynamic> json) {
    return SalaryType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

// ------------------------------------------------------------
// JOB TYPE MODEL
// ------------------------------------------------------------
class JobPostJobType {
  final String id;
  final String name;

  JobPostJobType({
    required this.id,
    required this.name,
  });

  factory JobPostJobType.fromJson(Map<String, dynamic> json) {
    return JobPostJobType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

// ------------------------------------------------------------
// COUNTRY MODEL
// ------------------------------------------------------------
class JobPostCountry {
  final int id;
  final String name;
  final String code;

  JobPostCountry({
    required this.id,
    required this.name,
    required this.code,
  });

  factory JobPostCountry.fromJson(Map<String, dynamic> json) {
    return JobPostCountry(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

// ------------------------------------------------------------
// STATE MODEL
// ------------------------------------------------------------
class JobPostState {
  final int id;
  final int countryId;
  final String name;
  final String code;

  JobPostState({
    required this.id,
    required this.countryId,
    required this.name,
    required this.code,
  });

  factory JobPostState.fromJson(Map<String, dynamic> json) {
    return JobPostState(
      id: json['id'] ?? 0,
      countryId: json['country_id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

// ------------------------------------------------------------
// EMPLOYER MODEL
// ------------------------------------------------------------
class JobPostEmployer {
  final int id;
  final String businessName;
  final String? businessType;
  final JobPostCountry country;
  final JobPostState state;
  final String city;
  final String? profileImage;

  JobPostEmployer({
    required this.id,
    required this.businessName,
    this.businessType,
    required this.country,
    required this.state,
    required this.city,
    this.profileImage,
  });

  factory JobPostEmployer.fromJson(Map<String, dynamic> json) {
    return JobPostEmployer(
      id: json['id'] ?? 0,
      businessName: json['business_name'] ?? '',
      businessType: json['business_type'],
      country: JobPostCountry.fromJson(json['country']),
      state: JobPostState.fromJson(json['state']),
      city: json['city'] ?? '',
      profileImage: json['profile_image'],
    );
  }
}

// ------------------------------------------------------------
// SKILL MODEL
// ------------------------------------------------------------
class JobPostSkill {
  final int id;
  final String name;
  final int isRequired;

  JobPostSkill({
    required this.id,
    required this.name,
    required this.isRequired,
  });

  factory JobPostSkill.fromJson(Map<String, dynamic> json) {
    return JobPostSkill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isRequired: json['is_required'] ?? 0,
    );
  }
}
