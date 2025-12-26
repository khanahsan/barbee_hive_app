class FeedbackSupportResponse {
  bool status;
  String message;
  FeedbackSupportData data;

  FeedbackSupportResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  // Factory method to parse JSON data
  factory FeedbackSupportResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackSupportResponse(
      status: json['status'],
      message: json['message'],
      data: FeedbackSupportData.fromJson(json['data']),
    );
  }
}

class FeedbackSupportData {
  String? name;
  String? email;
  String? companyName;
  String? telephoneNo;
  String description;
  String type;
  String status;
  String updatedAt;
  String createdAt;
  int id;

  FeedbackSupportData({
    this.name,
    this.email,
    this.companyName,
    this.telephoneNo,
    required this.description,
    required this.type,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  // Factory method to parse JSON data
  factory FeedbackSupportData.fromJson(Map<String, dynamic> json) {
    return FeedbackSupportData(
      name: json['name'],
      email: json['email'],
      companyName: json['company_name'],
      telephoneNo: json['telephone_no'],
      description: json['description'],
      type: json['type'],
      status: json['status'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }
}
