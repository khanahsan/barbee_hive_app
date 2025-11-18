// job_type_model.dart

class JobTypeResponse {
  final bool status;
  final String message;
  final List<JobType> data;

  JobTypeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobTypeResponse.fromJson(Map<String, dynamic> json) {
    return JobTypeResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => JobType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class JobType {
  final String id;
  final String name;

  JobType({
    required this.id,
    required this.name,
  });

  factory JobType.fromJson(Map<String, dynamic> json) {
    return JobType(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
