import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:t_db/t_db.dart';

class ApyarTdbAdapter extends TDAdapter<Apyar> {
  @override
  fromMap(Map<String, dynamic> map) {
    return Apyar.fromJson(map);
  }

  @override
  int getUniqueFieldId() {
    return 1;
  }

  @override
  Map<String, dynamic> toMap(Apyar value) {
    return value.toJson();
  }

  @override
  int getId(Apyar value) {
    return value.autoId;
  }
}

class ApyarContentTdbAdapter extends TDAdapter<ApyarContent> {
  @override
  ApyarContent fromMap(Map<String, dynamic> map) {
    return ApyarContent.fromJson(map);
  }

  @override
  int getUniqueFieldId() {
    return 2;
  }

  @override
  Map<String, dynamic> toMap(ApyarContent value) {
    return value.toJson();
  }

  @override
  int getId(ApyarContent value) {
    return value.autoId;
  }
}
