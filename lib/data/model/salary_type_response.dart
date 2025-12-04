// salary_type_response_model.dart

class SalaryTypeResponse {
  bool status;
  String message;
  List<SalaryType> data;

  SalaryTypeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SalaryTypeResponse.fromJson(Map<String, dynamic> json) {
    return SalaryTypeResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => SalaryType.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class SalaryType {
  String id;
  String name;

  SalaryType({
    required this.id,
    required this.name,
  });

  factory SalaryType.fromJson(Map<String, dynamic> json) {
    return SalaryType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
