class DurationModel {
  final int days;
  final double amount;

  DurationModel({required this.days, required this.amount});

  // Factory method to create an instance from JSON data
  factory DurationModel.fromJson(Map<String, dynamic> json) {
    return DurationModel(
      days: json['days'],
      amount: json['amount'].toDouble(),
    );
  }

  // Method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'amount': amount,
    };
  }
}

class DurationResponse {
  final List<DurationModel> duration;

  DurationResponse({required this.duration});

  // Factory method to create an instance from JSON data
  factory DurationResponse.fromJson(Map<String, dynamic> json) {
    var list = json['duration'] as List;
    List<DurationModel> durationList = list.map((i) => DurationModel.fromJson(i)).toList();

    return DurationResponse(duration: durationList);
  }

  // Method to convert the DurationResponse instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'duration': duration.map((e) => e.toJson()).toList(),
    };
  }
}
