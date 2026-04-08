import 'package:t_db/t_db.dart';

class BookmarkAdapter extends TDAdapter<Bookmark> {
  @override
  Bookmark fromMap(Map<String, dynamic> map) {
    return Bookmark.fromMap(map);
  }

  @override
  int getId(Bookmark value) {
    return value.autoId;
  }

  @override
  int getUniqueFieldId() {
    return 3;
  }

  @override
  Map<String, dynamic> toMap(Bookmark value) {
    return value.toMap();
  }
}

class Bookmark {
  final int autoId;
  final int apyarId;
  final String title;
  final DateTime date;
  Bookmark({
    this.autoId = 0,
    required this.apyarId,
    required this.title,
    required this.date,
  });

  Bookmark copyWith({
    int? autoId,
    int? apyarId,
    String? title,
    DateTime? date,
  }) {
    return Bookmark(
      autoId: autoId ?? this.autoId,
      apyarId: apyarId ?? this.apyarId,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'autoId': autoId,
      'apyarId': apyarId,
      'title': title,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      autoId: map['autoId'] as int,
      apyarId: map['apyarId'] as int,
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }
}
