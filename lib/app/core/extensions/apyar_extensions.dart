import 'package:apyar_app/app/core/models/apyar.dart';

extension ApyarExtensions on List<Apyar> {
  void sortTitle({bool isAToZ = true}) {
    sort((a, b) {
      if (isAToZ) {
        return a.title.compareTo(b.title);
      } else {
        return b.title.compareTo(a.title);
      }
    });
  }

  void sortDate({bool isNewest = true}) {
    sort((a, b) {
      if (isNewest) {
        if (a.date.millisecondsSinceEpoch > b.date.millisecondsSinceEpoch) {
          return -1;
        }
        if (a.date.millisecondsSinceEpoch < b.date.millisecondsSinceEpoch) {
          return 1;
        }
      } else {
        if (a.date.millisecondsSinceEpoch > b.date.millisecondsSinceEpoch) {
          return 1;
        }
        if (a.date.millisecondsSinceEpoch < b.date.millisecondsSinceEpoch) {
          return -1;
        }
      }
      return 0;
    });
  }
}
