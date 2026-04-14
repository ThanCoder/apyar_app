import 'package:sm_db/sm_db.dart';

class ApyarContentAdapter extends JsonDBAdapter<ApyarContent> {
  @override
  ApyarContent fromMap(Map<String, dynamic> map) {
    return ApyarContent.fromMap(map);
  }

  @override
  int getParentId(ApyarContent value) {
    return value.apyarId;
  }

  @override
  int get getUniqueFieldId => 2;

  @override
  Map<String, dynamic> toMap(ApyarContent value) {
    return value.toMap();
  }

  @override
  int getId(ApyarContent value) {
    return value.id;
  }
}

class ApyarContent {
  final int id;
  final int apyarId;
  final int chapter;
  final String body;
  final DateTime date;
  ApyarContent({
    this.id = 0,
    required this.apyarId,
    required this.chapter,
    required this.body,
    required this.date,
  });

  ApyarContent copyWith({
    int? id,
    int? apyarId,
    int? chapter,
    String? body,
    DateTime? date,
  }) {
    return ApyarContent(
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

  factory ApyarContent.fromMap(Map<String, dynamic> map) {
    return ApyarContent(
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
