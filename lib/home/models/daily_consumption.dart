class DailyConsumption {
  final int? id;
  final int? trackItem;
  final String? trackItemName;
  final String date;
  final int? units;

  DailyConsumption({
    required this.id,
    required this.trackItem,
    required this.trackItemName,
    required this.date,
    this.units,
  });

  factory DailyConsumption.fromJson(Map<String, dynamic> json) {
    return DailyConsumption(
      id: json['id'] ?? 0,
      trackItem: json['track_item'] ?? 0,
      trackItemName: json['track_item_name'] ?? 0,
      date: json['date'],
       units: json['units'] != null 
          ? int.tryParse(json['units'].toString()) ?? 0 
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'track_item': trackItem,
      'date': date,
      'units': units,
    };
  }
}

