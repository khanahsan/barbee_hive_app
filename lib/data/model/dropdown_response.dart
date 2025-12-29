class DropdownResponse {
  final bool status;
  final String message;
  final DropdownData data;

  DropdownResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DropdownResponse.fromJson(Map<String, dynamic> json) {
    return DropdownResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: DropdownData.fromJson(json['data'] ?? {}),
    );
  }
}

class DropdownData {
  final List<DropdownItem> eyeColors;
  final List<DropdownItem> hairColors;
  final List<DropdownItem> skills;
  final List<DropdownItem> experienceLevels;
  final List<DropdownItem> jobTypes;
  final List<DropdownItem> genders;
  final List<DropdownItem> heights;
  final List<DropdownItem> salaryTypes;
  final List<DropdownItem> countries;
  final List<DropdownItem> states;
  final List<DropdownItem> contactTypes;

  DropdownData({
    required this.eyeColors,
    required this.hairColors,
    required this.skills,
    required this.experienceLevels,
    required this.jobTypes,
    required this.genders,
    required this.heights,
    required this.salaryTypes,
    required this.countries,
    required this.states,
    required this.contactTypes,
  });

  factory DropdownData.fromJson(Map<String, dynamic> json) {
    return DropdownData(
      eyeColors: _parseDropdownList(json['eye-colors']),
      hairColors: _parseDropdownList(json['hair-colors']),
      skills: _parseDropdownList(json['skills']),
      experienceLevels: _parseDropdownList(json['experience-levels']),
      jobTypes: _parseDropdownList(json['job-types']),
      genders: _parseDropdownList(json['genders']),
      heights: _parseDropdownList(json['heights']),
      salaryTypes: _parseDropdownList(json['salary-types']),
      countries: _parseDropdownList(json['countries']),
      states: _parseDropdownList(json['states']),
      contactTypes: _parseDropdownList(json['contact-types']),
    );
  }

  static List<DropdownItem> _parseDropdownList(dynamic data) {
    if (data == null) return [];
    return (data as List<dynamic>)
        .map((e) => DropdownItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class DropdownItem {
  final dynamic id; // Can be int or String
  final String name;

  DropdownItem({
    required this.id,
    required this.name,
  });

  factory DropdownItem.fromJson(Map<String, dynamic> json) {
    return DropdownItem(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
