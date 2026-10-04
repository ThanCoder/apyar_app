import 'package:apyar_app/ui/settings/custom_path_form.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MorePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More")),
      body: SingleChildScrollView(
        child: Column(
          spacing: 8,
          children: [TMaterialThemeProviderChooser(), CustomPathForm()],
        ),
      ),
    );
  }
}
