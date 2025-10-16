class JobApplicationResponse {
  final bool status;
  final String message;
  final List<JobApplicationData> data;

  JobApplicationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobApplicationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return JobApplicationResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (data is List)
              ? data.map((item) => JobApplicationData.fromJson(item)).toList()
              : [JobApplicationData.fromJson(data)],
      // data:
      //     (json['data'] as List<dynamic>?)
      //         ?.map((item) => JobApplicationData.fromJson(item))
      //         .toList() ??
      //     [],
    );
  }
}

class JobApplicationData {
  final int id;
  final JobSummary job;
  final Applicant applicant;
  final String experienceLevel;
  final int yearsOfExperience;
  final String jobType;
  final String expectedSalary;
  final String status;
  final String createdAt;
  final String updatedAt;

  JobApplicationData({
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

  factory JobApplicationData.fromJson(Map<String, dynamic> json) {
    return JobApplicationData(
      id: json['id'] ?? 0,
      job: JobSummary.fromJson(json['job']),
      applicant: Applicant.fromJson(json['applicant']),
      experienceLevel: json['experience_level'] ?? '',
      yearsOfExperience: json['years_of_experience'] ?? 0,
      jobType: json['job_type'] ?? '',
      expectedSalary: json['expected_salary'] ?? '0.00',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class JobSummary {
  final int id;
  final String title;
  final String company;

  JobSummary({required this.id, required this.title, required this.company});

  factory JobSummary.fromJson(Map<String, dynamic> json) {
    return JobSummary(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      company: json['company'] ?? '',
    );
  }
}

class Applicant {
  final int id;
  final String uid;
  final String? name;
  final String email;
  final String? phone;
  final String? country;
  final String? state;
  final String? city;
  final String? profileImage;
  final String? position;
  final int age;
  final String? experienceYears;
  final String gender;
  final Skill? skills;

  Applicant({
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

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      id: json['id'] ?? 0,
      uid: json['uid'] ?? '',
      name: json['name'],
      email: json['email'] ?? '',
      phone: json['phone'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      profileImage: json['profile_image'],
      position: json['position'],
      age: json['age'] ?? 0,
      experienceYears: json['experience_years'],
      gender: json['gender'] ?? '',
      skills: json['skills'] != null ? Skill.fromJson(json['skills']) : null,
    );
  }
}

class Skill {
  final int id;
  final String name;

  Skill({required this.id, required this.name});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
