import 'package:flutter/material.dart';
import 'package:thancoder_pre_app/more_libs/setting/setting.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(Setting.instance.appName)));
  }
}
