import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:sm_db/sm_db.dart';

class ApyarSmdbAdapter extends SMDBJsonAdapter<Apyar> {
  @override
  Apyar fromMap(Map<String, dynamic> map) {
    return Apyar.fromJson(map);
  }

  @override
  int getId(Apyar value) {
    return value.id;
  }

  @override
  Map<String, dynamic> toMap(Apyar value) {
    return value.toJson();
  }

  @override
  int get adapterTypeId => 1;
}

class ApyarContentSmdbAdapter extends SMDBJsonAdapter<ApyarContent> {
  @override
  ApyarContent fromMap(Map<String, dynamic> map) {
    return ApyarContent.fromJson(map);
  }

  @override
  int getId(ApyarContent value) {
    return value.id;
  }

  @override
  int get adapterTypeId => 2;

  @override
  Map<String, dynamic> toMap(ApyarContent value) {
    return value.toJson();
  }

  @override
  int getParentId(ApyarContent value) {
    return value.apyarId;
  }
}
