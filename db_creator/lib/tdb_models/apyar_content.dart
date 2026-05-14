import 'package:t_db/t_db.dart';

class ApyarContentAdapter extends TDAdapter<Content> {
  @override
  Content fromMap(Map<String, dynamic> map) {
    return Content.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(Content value) {
    return value.toMap();
  }

  @override
  int getId(Content value) {
    return value.id;
  }

  @override
  int getUniqueFieldId() => 2;
}

class Content {
  final int id;
  final int apyarId;
  final int chapter;
  final String body;
  final DateTime date;
  Content({
    this.id = 0,
    required this.apyarId,
    required this.chapter,
    required this.body,
    required this.date,
  });

  Content copyWith({
    int? id,
    int? apyarId,
    int? chapter,
    String? body,
    DateTime? date,
  }) {
    return Content(
      id: id ?? this.id,
      apyarId: apyarId ?? this.apyarId,
      chapter: chapter ?? this.chapter,
      body: body ?? this.body,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'apyarId': apyarId,
      'chapter': chapter,
      'body': body,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      id: map['id'] as int,
      apyarId: map['apyarId'] as int,
      chapter: map['chapter'] as int,
      body: map['body'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  @override
  String toString() {
    return 'ID: $id - apyarID: $apyarId';
  }
}
