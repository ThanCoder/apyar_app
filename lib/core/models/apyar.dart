// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:dual_store/dual_store.dart';

class Apyar extends DualModel {
  final int id;
  final String title;
  final DateTime date;
  Apyar({this.id = -1, required this.title, required this.date});

  @override
  String toString() => 'Apyar(id: $id, title: $title, date: $date)';

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

  Apyar copyWith({
    int? id,
    String? title,
    DateTime? date,
  }) {
    return Apyar(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }
}

class ApyarAdapter extends DualAdapter<Apyar> {
  @override
  int get adapterTypeId => 1;

  @override
  Apyar fromSmallData(SmallDataDecoder decoder) {
    return Apyar(
      id: decoder.getInt(1),
      title: decoder.getString(2),
      date: DateTime.fromMillisecondsSinceEpoch(decoder.getInt(3)),
    );
  }

  @override
  int getId(Apyar value) {
    return value.id;
  }

  @override
  Uint8List toSmallData(
    Apyar value,
    int generatedAutoId,
    SmallDataEncoder encoder,
  ) {
    encoder.writeInt(1, generatedAutoId);
    encoder.writeString(2, value.title);
    encoder.writeInt(3, value.date.millisecondsSinceEpoch);
    return encoder.finishedBytes;
  }
}
