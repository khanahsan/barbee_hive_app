/*



// -------------------------------
// JOB APPLICATION RESPONSE MODEL
// -------------------------------

// class JobApplyResponse {
//   final bool status;
//   final String message;
//   final List<JobApplyData> data;
//
//   JobApplyResponse({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//
//   factory JobApplyResponse.fromJson(Map<String, dynamic> json) {
//     final data = json['data'];
//
//     // If data is a list, map it; otherwise, wrap single object in a list
//     return JobApplyResponse(
//       status: json['status'] ?? false,
//       message: json['message'] ?? '',
//       data: (data is List)
//           ? data.map((item) => JobApplyData.fromJson(item)).toList()
//           : [JobApplyData.fromJson(data)],
//     );
//   }
// }


class JobApplyResponse {
  final bool status;
  final String message;
  final List<JobApplyData> data; // Always as a list internally

  JobApplyResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobApplyResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];

    List<JobApplyData> parsedData;

    if (dataJson is List) {
      // If data is already a list
      parsedData = dataJson.map((item) => JobApplyData.fromJson(item)).toList();
    } else if (dataJson is Map<String, dynamic>) {
      // If data is a single object, wrap it in a list
      parsedData = [JobApplyData.fromJson(dataJson)];
    } else {
      parsedData = [];
    }

    return JobApplyResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
    );
  }
}


class JobApplyData {
  final int id;
  final JobApplySummary job;
  final JobApplyApplicant applicant;
  final JobApplyLevel experienceLevel;
  final int yearsOfExperience;
  final JobApplyLevel jobType;
  final String expectedSalary;
  final String status;
  final String createdAt;
  final String updatedAt;

  JobApplyData({
    required this.id,
    required this.job,
    required this.applicant,
    required this.experienceLevel,
    required this.yearsOfExperience,
    required this.jobType,
    required this.expectedSalary,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobApplyData.fromJson(Map<String, dynamic> json) {
    return JobApplyData(
      id: json['id'] ?? 0,
      job: JobApplySummary.fromJson(json['job']),
      applicant: JobApplyApplicant.fromJson(json['applicant']),
      experienceLevel: JobApplyLevel.fromJson(json['experience_level']),
      yearsOfExperience: json['years_of_experience'] ?? 0,
      jobType: JobApplyLevel.fromJson(json['job_type']),
      expectedSalary: json['expected_salary'] ?? '0.00',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

// -------------------------------
// JOB SUMMARY
// -------------------------------

class JobApplySummary {
  final int id;
  final String title;
  final String company;

  JobApplySummary({
    required this.id,
    required this.title,
    required this.company,
  });

  factory JobApplySummary.fromJson(Map<String, dynamic> json) {
    return JobApplySummary(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      company: json['company'] ?? '',
    );
  }
}

// -------------------------------
// APPLICANT MODEL
// -------------------------------

class JobApplyApplicant {
  final int id;
  final String uid;
  final String? name;
  final String email;
  final String? phone;
  final JobApplyCountry? country;
  final JobApplyState? state;
  final String? city;
  final String? profileImage;
  final String? position;
  final int age;
  final String? experienceYears;
  final String gender;
  final JobApplySkill? skills;

  JobApplyApplicant({
    required this.id,
    required this.uid,
    this.name,
    required this.email,
    this.phone,
    this.country,
    this.state,
    this.city,
    this.profileImage,
    this.position,
    required this.age,
    this.experienceYears,
    required this.gender,
    this.skills,
  });

  factory JobApplyApplicant.fromJson(Map<String, dynamic> json) {
    return JobApplyApplicant(
      id: json['id'] ?? 0,
      uid: json['uid'] ?? '',
      name: json['name'],
      email: json['email'] ?? '',
      phone: json['phone'],
      country: json['country'] != null
          ? JobApplyCountry.fromJson(json['country'])
          : null,
      state: json['state'] != null ? JobApplyState.fromJson(json['state']) : null,
      city: json['city'],
      profileImage: json['profile_image'],
      position: json['position'],
      age: json['age'] ?? 0,
      experienceYears: json['experience_years'],
      gender: json['gender'] ?? '',
      skills: json['skills'] != null ? JobApplySkill.fromJson(json['skills']) : null,
    );
  }
}

// -------------------------------
// NESTED MODELS
// -------------------------------

class JobApplyCountry {
  final int id;
  final String name;
  final String code;

  JobApplyCountry({required this.id, required this.name, required this.code});

  factory JobApplyCountry.fromJson(Map<String, dynamic> json) {
    return JobApplyCountry(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class JobApplyState {
  final int id;
  final int countryId;
  final String name;
  final String code;

  JobApplyState({
    required this.id,
    required this.countryId,
    required this.name,
    required this.code,
  });

  factory JobApplyState.fromJson(Map<String, dynamic> json) {
    return JobApplyState(
      id: json['id'] ?? 0,
      countryId: json['country_id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class JobApplySkill {
  final int id;
  final String name;

  JobApplySkill({required this.id, required this.name});

  factory JobApplySkill.fromJson(Map<String, dynamic> json) {
    return JobApplySkill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

// -------------------------------
// EXPERIENCE LEVEL & JOB TYPE MODEL
// -------------------------------

class JobApplyLevel {
  final String id;
  final String name;

  JobApplyLevel({required this.id, required this.name});

  factory JobApplyLevel.fromJson(Map<String, dynamic> json) {
    return JobApplyLevel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

*/


// -------------------------------
// JOB APPLICATION RESPONSE MODEL
// -------------------------------

class JobApplyResponse {
  final bool status;
  final String message;
  final List<JobApplyData> data; // Always a list internally

  JobApplyResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobApplyResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];

    List<JobApplyData> parsedData;

    if (dataJson is List) {
      parsedData = dataJson.map((item) => JobApplyData.fromJson(item)).toList();
    } else if (dataJson is Map<String, dynamic>) {
      parsedData = [JobApplyData.fromJson(dataJson)];
    } else {
      parsedData = [];
    }

    return JobApplyResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
    );
  }
}

// -------------------------------
// JOB DATA
// -------------------------------

class JobApplyData {
  final int id;
  final JobApplySummary job;
  final JobApplyApplicant applicant;
  final JobApplyLevel experienceLevel;
  final int yearsOfExperience;
  final JobApplyLevel jobType;
  final String expectedSalary;
  final String status;
  final String createdAt;
  final String updatedAt;

  JobApplyData({
    required this.id,
    required this.job,
    required this.applicant,
    required this.experienceLevel,
    required this.yearsOfExperience,
    required this.jobType,
    required this.expectedSalary,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobApplyData.fromJson(Map<String, dynamic> json) {
    return JobApplyData(
      id: json['id'] ?? 0,
      job: JobApplySummary.fromJson(json['job']),
      applicant: JobApplyApplicant.fromJson(json['applicant']),
      experienceLevel: JobApplyLevel.fromJson(json['experience_level']),
      yearsOfExperience: json['years_of_experience'] ?? 0,
      jobType: JobApplyLevel.fromJson(json['job_type']),
      expectedSalary: json['expected_salary'] ?? '0.00',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

// -------------------------------
// JOB SUMMARY
// -------------------------------

class JobApplySummary {
  final int id;
  final String title;
  final String company;

  JobApplySummary({
    required this.id,
    required this.title,
    required this.company,
  });

  factory JobApplySummary.fromJson(Map<String, dynamic> json) {
    return JobApplySummary(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      company: json['company'] ?? '',
    );
  }
}

// -------------------------------
// APPLICANT
// -------------------------------

class JobApplyApplicant {
  final int id;
  final String uid;
  final String? name;
  final String email;
  final String? phone;
  final JobApplyCountry? country;
  final JobApplyState? state;
  final String? city;
  final String? profileImage;
  final String? position;
  final int age;
  final String? experienceYears;
  final String gender;
  final String? resumeUrl;
  final List<JobApplySkill>? skills; // Always list internally

  JobApplyApplicant({
    required this.id,
    required this.uid,
    this.name,
    required this.email,
    this.phone,
    this.country,
    this.state,
    this.city,
    this.profileImage,
    this.position,
    required this.age,
    this.experienceYears,
    required this.gender,
    this.resumeUrl,
    this.skills,
  });

  factory JobApplyApplicant.fromJson(Map<String, dynamic> json) {
    final skillsJson = json['skills'];

    List<JobApplySkill>? parsedSkills;

    if (skillsJson is List) {
      parsedSkills = skillsJson.map((e) => JobApplySkill.fromJson(e)).toList();
    } else if (skillsJson is Map<String, dynamic>) {
      parsedSkills = [JobApplySkill.fromJson(skillsJson)];
    } else {
      parsedSkills = null;
    }

    return JobApplyApplicant(
      id: json['id'] ?? 0,
      uid: json['uid'] ?? '',
      name: json['name'],
      email: json['email'] ?? '',
      phone: json['phone'],
      country: json['country'] != null
          ? JobApplyCountry.fromJson(json['country'])
          : null,
      state: json['state'] != null
          ? JobApplyState.fromJson(json['state'])
          : null,
      city: json['city'],
      profileImage: json['profile_image'],
      position: json['position'],
      age: json['age'] ?? 0,
      experienceYears: json['experience_years'],
      gender: json['gender'] ?? '',
      resumeUrl: json['resume_url'] ?? '',
      skills: parsedSkills,
    );
  }
}

// -------------------------------
// NESTED MODELS
// -------------------------------

class JobApplyCountry {
  final int id;
  final String name;
  final String code;

  JobApplyCountry({required this.id, required this.name, required this.code});

  factory JobApplyCountry.fromJson(Map<String, dynamic> json) {
    return JobApplyCountry(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class JobApplyState {
  final int id;
  final int countryId;
  final String name;
  final String code;

  JobApplyState({
    required this.id,
    required this.countryId,
    required this.name,
    required this.code,
  });

  factory JobApplyState.fromJson(Map<String, dynamic> json) {
    return JobApplyState(
      id: json['id'] ?? 0,
      countryId: json['country_id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class JobApplySkill {
  final int id;
  final String name;

  JobApplySkill({required this.id, required this.name});

  factory JobApplySkill.fromJson(Map<String, dynamic> json) {
    return JobApplySkill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

// -------------------------------
// EXPERIENCE LEVEL & JOB TYPE
// -------------------------------

class JobApplyLevel {
  final String id;
  final String name;

  JobApplyLevel({required this.id, required this.name});

  factory JobApplyLevel.fromJson(Map<String, dynamic> json) {
    return JobApplyLevel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
