import 'dart:io';

import 'package:t_db/t_db.dart';

class ApyarAdapter extends TDAdapter<Apyar> {
  @override
  fromMap(Map<String, dynamic> map) {
    return Apyar.fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(Apyar value) {
    return value.toJson();
  }

  @override
  int getId(Apyar value) {
    return value.autoId;
  }

  @override
  int getUniqueFieldId() => 1;
}

class Apyar {
  final int autoId;
  final String title;
  final DateTime date;

  const Apyar({this.autoId = 0, required this.title, required this.date});

  static Future<Apyar?> fromDir(Directory dir) async {
    if (!dir.existsSync()) {
      return null;
    }
    final title = dir.path.split('/').last.trim();
    return Apyar(title: title, date: DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'autoId': autoId,
      'title': title,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Apyar.fromJson(Map<String, dynamic> json) {
    return Apyar(
      autoId: json['autoId'],
      title: json['title'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }

  @override
  String toString() => '''Apyar(autoId: $autoId, title: $title, date: $date)''';
}
