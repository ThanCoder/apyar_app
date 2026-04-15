class ApyarContent {
  final int id;
  final int autoId;
  final int apyarId;
  final int chapter;
  final String body;
  final DateTime date;
  ApyarContent({
    this.id = 0,
    this.autoId = 0,
    required this.apyarId,
    required this.chapter,
    required this.body,
    required this.date,
  });

  @override
  String toString() {
    return 'ID: $autoId - apyarID: $apyarId';
  }

  ApyarContent copyWith({
    int? id,
    int? autoId,
    int? apyarId,
    int? chapter,
    String? body,
    DateTime? date,
  }) {
    return ApyarContent(
      id: id ?? this.id,
      autoId: autoId ?? this.autoId,
      apyarId: apyarId ?? this.apyarId,
      chapter: chapter ?? this.chapter,
      body: body ?? this.body,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'autoId': autoId,
      'apyarId': apyarId,
      'chapter': chapter,
      'body': body,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory ApyarContent.fromJson(Map<String, dynamic> json) {
    return ApyarContent(
      id: json['id'] ?? 0,
      autoId: json['autoId'] ?? 0,
      apyarId: json['apyarId'],
      chapter: json['chapter'],
      body: json['body'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }
}
