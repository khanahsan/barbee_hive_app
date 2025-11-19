class HeightResponse {
  final bool status;
  final String message;
  final List<Height> data;

  HeightResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HeightResponse.fromJson(Map<String, dynamic> json) {
    return HeightResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Height.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Height {
  final int id;
  final String name;

  Height({
    required this.id,
    required this.name,
  });

  factory Height.fromJson(Map<String, dynamic> json) {
    return Height(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
