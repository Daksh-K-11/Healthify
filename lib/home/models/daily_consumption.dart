class DailyConsumption {
  final int id;
  final int trackItem;
  final String trackItemName;
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
      id: json['id'],
      trackItem: json['track_item'],
      trackItemName: json['track_item_name'],
      date: json['date'],
      units: json['units'],
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

