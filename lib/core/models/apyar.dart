class Apyar {
  final int id;
  final int autoId;
  final String title;
  final DateTime date;
  const Apyar({
    this.id = 0,
    this.autoId = 0,
    required this.title,
    required this.date,
  });

  @override
  String toString() {
    return 'ID: $autoId - title: $title';
  }

  factory Apyar.empty({required String title}) {
    return Apyar(autoId: 0, title: title, date: DateTime.now());
  }

  Apyar copyWith({int? id, int? autoId, String? title, DateTime? date}) {
    return Apyar(
      id: id ?? this.id,
      autoId: autoId ?? this.autoId,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'autoId': autoId,
      'title': title,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Apyar.fromJson(Map<String, dynamic> json) {
    return Apyar(
      id: json['id'] ?? 0,
      autoId: json['autoId'] ?? 0,
      title: json['title'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }
}
