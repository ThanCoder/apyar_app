import 'dart:io';

import 'package:t_db/t_db.dart';

class ApyarAdapter extends TDAdapter<Apyar> {
  @override
  fromMap(Map<String, dynamic> map) {
    return Apyar.fromMap(map);
  }

  @override
  int getUniqueFieldId() {
    return 1;
  }

  @override
  Map<String, dynamic> toMap(Apyar value) {
    return value.toMap();
  }

  @override
  int getId(Apyar value) {
    return value.autoId;
  }
}

class Apyar {
  final int autoId;
  final String title;
  final DateTime date;
  Apyar({this.autoId = 0, required this.title, required this.date});

  Apyar copyWith({int? autoId, String? title, String? body, DateTime? date}) {
    return Apyar(
      autoId: autoId ?? this.autoId,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }

  static Future<Apyar?> fromDir(Directory dir) async {
    if (!dir.existsSync()) {
      return null;
    }
    final title = dir.path.split('/').last.trim();
    return Apyar(title: title, date: DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'autoId': autoId,
      'title': title,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Apyar.fromMap(Map<String, dynamic> map) {
    return Apyar(
      autoId: map['autoId'] as int,
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }
  @override
  String toString() {
    return 'ID: $autoId - title: $title';
  }
}
