import 'package:t_db/t_db.dart';

class ApyarContentAdapter extends TDAdapter<ApyarContent> {
  @override
  ApyarContent fromMap(Map<String, dynamic> map) {
    return ApyarContent.fromMap(map);
  }

  @override
  int getUniqueFieldId() {
    return 2;
  }

  @override
  Map<String, dynamic> toMap(ApyarContent value) {
    return value.toMap();
  }
  
  @override
  int getId(ApyarContent value) {
    return value.autoId;
  }
}

class ApyarContent {
  final int autoId;
  final int apyarId;
  final int chapter;
  final String body;
  final DateTime date;
  ApyarContent({
    this.autoId = 0,
    required this.apyarId,
    required this.chapter,
    required this.body,
    required this.date,
  });

  ApyarContent copyWith({
    int? autoId,
    int? apyarId,
    int? chapter,
    String? body,
    DateTime? date,
  }) {
    return ApyarContent(
      autoId: autoId ?? this.autoId,
      apyarId: apyarId ?? this.apyarId,
      chapter: chapter ?? this.chapter,
      body: body ?? this.body,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'autoId': autoId,
      'apyarId': apyarId,
      'chapter': chapter,
      'body': body,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory ApyarContent.fromMap(Map<String, dynamic> map) {
    return ApyarContent(
      autoId: map['autoId'] as int,
      apyarId: map['apyarId'] as int,
      chapter: map['chapter'] as int,
      body: map['body'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  @override
  String toString() {
    return 'ID: $autoId - apyarID: $apyarId';
  }
}
