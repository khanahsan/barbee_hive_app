// country_model.dart

class CountryResponse {
  final bool status;
  final String message;
  final List<Country> data;

  CountryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => Country.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((country) => country.toJson()).toList(),
    };
  }
}

class Country {
  final int id;
  final String name;

  Country({
    required this.id,
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
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
