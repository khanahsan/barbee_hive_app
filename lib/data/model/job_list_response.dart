

class JobListResponse {
  final bool status;
  final String message;
  final List<JobListData> data;

  JobListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobListResponse.fromJson(Map<String, dynamic> json) {
    return JobListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
              .map((e) => JobListData.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class JobListData {
  final int id;
  final String title;
  final String description;
  final String experienceLevel;
  final JobListSalaryRange salaryRange;
  final JobListJobType jobType;
  final JobListCountry? country;
  final JobListState? state;
  final String city;
  final String recruiterName;
  final String? image;
  final bool isActive;
  final String expiresAt;
  final int remainingHours;
  final JobListEmployer employer;
  final JobListSkills skills;
  final int isApplied;

  JobListData({
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
    required this.skills,
    required this.isApplied,
  });

  factory JobListData.fromJson(Map<String, dynamic> json) {
    return JobListData(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      experienceLevel: json['experience_level'] ?? "",
      salaryRange: json['salary_range'] != null
          ? JobListSalaryRange.fromJson(json['salary_range'])
          : JobListSalaryRange(min: "", max: "", type: JobListSalaryType(id: "", name: "")),
      jobType: json['job_type'] != null
          ? JobListJobType.fromJson(json['job_type'])
          : JobListJobType(id: "", name: ""),
      country: json['country'] != null
          ? JobListCountry.fromJson(json['country'])
          : null,
      state: json['state'] != null
          ? JobListState.fromJson(json['state'])
          : null,
      city: json['city'] ?? "",
      recruiterName: json['recruiter_name'] ?? "",
      image: json['image'],
      isActive: json['is_active'] ?? false,
      expiresAt: json['expires_at'] ?? "",
      remainingHours: json['remaining_hours'] ?? 0,
      employer: json['employer'] != null
          ? JobListEmployer.fromJson(json['employer'])
          : JobListEmployer(id: 0, businessName: "", businessType: null, country: JobListCountry(id: 0, name: "", code: ""), state: JobListState(id: 0, countryId: 0, name: "", code: ""), city: "", profileImage: ""),
      skills: json['skills'] != null
          ? JobListSkills.fromJson(json['skills'])
          : JobListSkills(id: 0, name: "", isRequired: 0),
      isApplied: json['is_applied'] ?? 0,
    );
  }
}

class JobListSalaryRange {
  final String min;
  final String max;
  final JobListSalaryType type;

  JobListSalaryRange({
    required this.min,
    required this.max,
    required this.type,
  });

  factory JobListSalaryRange.fromJson(Map<String, dynamic> json) {
    final typeData = json['type'];

    return JobListSalaryRange(
      min: json['min'] ?? "",
      max: json['max'] ?? "",
      type: JobListSalaryType.fromDynamic(typeData),
    );
  }
}

class JobListSalaryType {
  final String id;
  final String name;

  JobListSalaryType({required this.id, required this.name});

  factory JobListSalaryType.fromDynamic(dynamic data) {
    // Case 1: employer response -> string
    if (data is String) {
      return JobListSalaryType(id: data, name: _capitalize(data));
    }

    // Case 2: employee response -> object
    if (data is Map<String, dynamic>) {
      return JobListSalaryType(id: data['id'] ?? "", name: data['name'] ?? "");
    }

    return JobListSalaryType(id: "", name: "");
  }
}

/// helper
String _capitalize(String s) {
  if (s.isEmpty) return s;
  return "${s[0].toUpperCase()}${s.substring(1)}";
}

class JobListJobType {
  final String id;
  final String name;

  JobListJobType({required this.id, required this.name});

  factory JobListJobType.fromJson(Map<String, dynamic> json) =>
      JobListJobType(
        id: json['id']?.toString() ?? "",
        name: json['name'] ?? "",
      );
}

class JobListCountry {
  final int id;
  final String name;
  final String code;

  JobListCountry({required this.id, required this.name, required this.code});

  factory JobListCountry.fromJson(Map<String, dynamic> json) {
    return JobListCountry(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      code: json['code'] ?? "",
    );
  }
}

class JobListState {
  final int id;
  final int countryId;
  final String name;
  final String code;

  JobListState({
    required this.id,
    required this.countryId,
    required this.name,
    required this.code,
  });

  factory JobListState.fromJson(Map<String, dynamic> json) {
    return JobListState(
      id: json['id'] ?? 0,
      countryId: json['country_id'] ?? 0,
      name: json['name'] ?? "",
      code: json['code'] ?? "",
    );
  }
}

class JobListEmployer {
  final int id;
  final String businessName;
  final String? businessType;
  final JobListCountry country;
  final JobListState state;
  final String city;
  final String profileImage;

  JobListEmployer({
    required this.id,
    required this.businessName,
    required this.businessType,
    required this.country,
    required this.state,
    required this.city,
    required this.profileImage,
  });

  factory JobListEmployer.fromJson(Map<String, dynamic> json) {
    return JobListEmployer(
      id: json['id'] ?? 0,
      businessName: json['business_name'] ?? "",
      businessType: json['business_type'],
      country: json['country'] != null
          ? JobListCountry.fromJson(json['country'])
          : JobListCountry(id: 0, name: "", code: ""),
      state: json['state'] != null
          ? JobListState.fromJson(json['state'])
          : JobListState(id: 0, countryId: 0, name: "", code: ""),
      city: json['city'] ?? "",
      profileImage: json['profile_image'] ?? "",
    );
  }
}

class JobListSkills {
  final int id;
  final String name;
  final int isRequired;

  JobListSkills({
    required this.id,
    required this.name,
    required this.isRequired,
  });

  factory JobListSkills.fromJson(Map<String, dynamic> json) {
    return JobListSkills(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      isRequired: json['is_required'] ?? 0,
    );
  }
}
