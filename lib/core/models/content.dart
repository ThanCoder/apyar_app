// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:dual_store/dual_store.dart';

class Content extends DualModel {
  final int id;
  final int apyarId;
  final int chapter;
  Content({this.id = -1, required this.apyarId, required this.chapter});

  @override
  String toString() => 'Content(id: $id, apyarId: $apyarId, chapter: $chapter)';

  Content copyWith({
    int? id,
    int? apyarId,
    int? chapter,
  }) {
    return Content(
      id: id ?? this.id,
      apyarId: apyarId ?? this.apyarId,
      chapter: chapter ?? this.chapter,
    );
  }
}

class ContentAdapter extends DualAdapter<Content> {
  @override
  int get adapterTypeId => 2;

  @override
  Content fromSmallData(SmallDataDecoder decoder) {
    return Content(
      id: decoder.getInt(1),
      apyarId: decoder.getInt(2),
      chapter: decoder.getInt(3),
    );
  }

  @override
  int getId(Content value) {
    return value.id;
  }

  @override
  int getParentId(Content value) {
    return value.apyarId;
  }

  @override
  Uint8List toSmallData(
    Content value,
    int generatedAutoId,
    SmallDataEncoder encoder,
  ) {
    encoder.writeInt(1, generatedAutoId);
    encoder.writeInt(2, value.apyarId);
    encoder.writeInt(3, value.chapter);
    return encoder.finishedBytes;
  }

  @override
  BigDataType get bigDataType => BigDataType.stringText;
}
