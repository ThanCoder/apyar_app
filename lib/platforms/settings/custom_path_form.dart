import 'dart:async';
import 'dart:io';

import 'package:apyar_app/core/controllers/apyar/apyar_controller.dart';
import 'package:apyar_app/core/controllers/i_controller.dart';
import 'package:apyar_app/core/db/du_db.dart';
import 'package:apyar_app/core/utils/app_util.dart';
import 'package:apyar_app/keys.dart';
import 'package:apyar_app/platforms/components/dialog/snack_alert.dart';
import 'package:apyar_app/platforms/components/forms/input_text.dart';
import 'package:apyar_app/platforms/pages/fav/fav_controller.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_pkg_android/than_pkg_android.dart';

class CustomPathForm extends StatefulWidget {
  const new({super.key});

  @override
  State<CustomPathForm> createState() => _CustomPathFormState();
}

class _CustomPathFormState extends State<CustomPathForm> {
  StreamSubscription? _sub;
  @override
  void initState() {
    super.initState();
    _sub = cf.stream.put
        .where((e) => e.key == appDatabseCustomPathEnableKey)
        .listen((event) {
          if (!mounted) return;
          setCfPath();
        });
    setCfPath();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void setCfPath() {
    String defPath = '';
    if (Platform.isLinux) {
      defPath = Platform.environment['HOME']!
          .join('Downloads')
          .join('apyar.store');
    }
    if (Platform.isAndroid) {
      defPath = ThanPkgAndroid.getInstance.pathHandler.getDownloadPath().join(
        'apyar.store',
      );
    }
    controller.text = cf.getString(appDatabseCustomPathKey).emptyOr(defPath);
    setState(() {});
  }

  final cf = AppUtil.instance.config;
  final controller = TextEditingController();
  bool isChanged = false;

  void toggleCustom(bool enable) async {
    if (Platform.isAndroid) {
      final pkg = ThanPkgAndroid.getInstance.storagePermissionHandler;
      if (!await pkg.isStoragePermissionGranted()) {
        await pkg.requestStoragePermission();
        return;
      }
    }
    cf.putAndWriteAll(appDatabseCustomPathEnableKey, enable);

    //init
    ControllerManager.read<ApyarController>().init();
    ControllerManager.read<FavController>().init();
  }

  void savePath() async {
    final p = controller.text.trim();
    await cf.putAndWriteAll(appDatabseCustomPathKey, p);
    await DuDB.instance.changePath(p);
    isChanged = false;
    if (!mounted) return;
    setState(() {});
    showSnackbar(context, 'Saved');

    //init
    ControllerManager.read<ApyarController>().init();
    ControllerManager.read<FavController>().init();
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    final enable = cf.getBool(appDatabseCustomPathEnableKey);
    return Container(
      padding: .all(4),
      decoration: BoxDecoration(
        borderRadius: .circular(14),
        color: col.surfaceContainer,
      ),
      child: Column(
        spacing: 8,
        children: [
          Material(
            child: SwitchListTile.adaptive(
              tileColor: col.surfaceContainer,
              // shape: RoundedRectangleBorder(borderRadius: .circular(14)),
              title: Text('Custom Database Path'),
              value: enable,
              onChanged: toggleCustom,
            ),
          ),
          if (enable)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputText(
                controller: controller,
                maxLines: null,
                label: Text('Custom Path'),
                onChanged: (val) {
                  if (!isChanged) {
                    setState(() {
                      isChanged = true;
                    });
                  }
                },
              ),
            ),
          if (enable && isChanged)
            Row(
              children: [
                Spacer(),
                FilledButton(onPressed: savePath, child: Text('Save')),
              ],
            ),
        ],
      ),
    );
  }
}
