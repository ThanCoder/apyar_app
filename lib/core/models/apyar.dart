import 'package:dual_store/dual_store.dart';

class ApyarAdapter extends IDuBinaryMetaAdapter<Apyar> {
  @override
  Apyar fromMap(Map<String, dynamic> map) {
    return Apyar.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(Apyar value) {
    return value.toMap();
  }

  @override
  int get adapterId => 1;
}

class Apyar extends IDuModel {
  final String title;
  final DateTime date;
  Apyar({required this.title, required this.date});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Apyar.fromMap(Map<String, dynamic> map) {
    return Apyar(
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  @override
  String toString() => 'Apyar(title: $title, date: $date)';
}
