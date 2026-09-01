import 'package:dual_store/dual_store.dart';

class ApyarContentAdapter extends IDuBinaryMetaAdapter<ApyarContent> {
  @override
  ApyarContent fromMap(Map<String, dynamic> map) {
    return .fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(ApyarContent value) {
    return value.toMap();
  }

  @override
  int get adapterId => 2;

  @override
  int parentId(ApyarContent value) {
    return value.apyarId;
  }
}

class ApyarContent extends IDuModel {
  final int apyarId;
  final int chapter;
  final DateTime date;
  ApyarContent({
    required this.apyarId,
    required this.chapter,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apyarId': apyarId,
      'chapter': chapter,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory ApyarContent.fromMap(Map<String, dynamic> map) {
    return ApyarContent(
      apyarId: map['apyarId'] as int,
      chapter: map['chapter'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  @override
  String toString() =>
      'ApyarContent(apyarId: $apyarId, chapter: $chapter, date: $date)';
}
