class ContactTypesResponse {
  bool status;
  String message;
  List<ContactType> data;

  ContactTypesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  // Factory method to parse JSON data
  factory ContactTypesResponse.fromJson(Map<String, dynamic> json) {
    return ContactTypesResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => ContactType.fromJson(item))
          .toList(),
    );
  }
}

class ContactType {
  String id;
  String name;

  ContactType({
    required this.id,
    required this.name,
  });

  // Factory method to parse JSON data
  factory ContactType.fromJson(Map<String, dynamic> json) {
    return ContactType(
      id: json['id'],
      name: json['name'],
    );
  }
}
