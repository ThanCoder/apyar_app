import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MorePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More")),
      body: SingleChildScrollView(
        child: Column(children: [TMaterialThemeProviderChooser()]),
      ),
    );
  }
}
