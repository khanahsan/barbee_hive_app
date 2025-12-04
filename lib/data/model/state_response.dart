// state_model.dart

class StateResponse {
  final bool status;
  final String message;
  final List<StateModel> data;

  StateResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory StateResponse.fromJson(Map<String, dynamic> json) {
    return StateResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => StateModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((state) => state.toJson()).toList(),
    };
  }
}

class StateModel {
  final int id;
  final String name;

  StateModel({
    required this.id,
    required this.name,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
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
