import 'package:apyar_app/platforms/components/app_version_view.dart';
import 'package:apyar_app/platforms/pages/app_about_dialog.dart';
import 'package:apyar_app/platforms/pages/dev_pages/dev_route_tile.dart';
import 'package:apyar_app/platforms/settings/custom_path_form.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MorePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
            children: [
              TMaterialThemeProviderChooser(),
              AppVersionView(),

              CustomPathForm(),
              DevRouteTile(),
              AppAboutDialogListTile(appDesc: 'Apyar Text Reader App'),
            ],
          ),
        ),
      ),
    );
  }
}
