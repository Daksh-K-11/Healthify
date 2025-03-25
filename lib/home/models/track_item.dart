class TrackItem {
  final int id;
  final String name;

  TrackItem({
    required this.id,
    required this.name,
  });

  factory TrackItem.fromJson(Map<String, dynamic> json) {
    return TrackItem(
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

