import 'package:apyar_app/core/db/du_db.dart';
import 'package:apyar_app/platform_app.dart';
import 'package:flutter/material.dart';

void main() async {
  // home/thancoder/Documents/apyar.store

  await DuDB.instance.init();
  await DuDB.instance.open('/home/thancoder/Documents/apyar.store');

  runApp(const PlatformApp());
}
