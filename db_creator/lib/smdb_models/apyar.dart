import 'dart:io';

import 'package:sm_db/sm_db.dart';

class ApyarAdapter extends JsonDBAdapter<Apyar> {
  @override
  fromMap(Map<String, dynamic> map) {
    return Apyar.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(Apyar value) {
    return value.toMap();
  }

  @override
  int getId(Apyar value) {
    return value.id;
  }

  @override
  int get getUniqueFieldId => 1;
}

class Apyar {
  final int id;
  final String title;
  final DateTime date;
  const Apyar({this.id = 0, required this.title, required this.date});

  Apyar copyWith({int? id, String? title, String? body, DateTime? date}) {
    return Apyar(
      id: id ?? this.id,
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
      'id': id,
      'title': title,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Apyar.fromMap(Map<String, dynamic> map) {
    return Apyar(
      id: map['id'] as int,
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }
  @override
  String toString() {
    return 'ID: $id - title: $title';
  }

  static List<Apyar> exampleList = List.generate(
    10,
    (index) => Apyar(
      id: index,
      title: 'title $index',
      date: DateTime.now().add(Duration(days: index)),
    ),
  );

  factory Apyar.empty({required String title}) {
    return Apyar(id: 0, title: title, date: DateTime.now());
  }
}
