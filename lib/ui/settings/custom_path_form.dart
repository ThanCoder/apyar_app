import 'dart:async';

import 'package:apyar_app/core/db/du_db.dart';
import 'package:apyar_app/core/utils/app_util.dart';
import 'package:apyar_app/keys.dart';
import 'package:apyar_app/ui/platforms/components/dialog/snack_alert.dart';
import 'package:apyar_app/ui/platforms/components/forms/input_text.dart';
import 'package:flutter/material.dart';

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
          controller.text = cf.getString(appDatabseCustomPathKey);
          setState(() {});
        });
    controller.text = cf.getString(appDatabseCustomPathKey);
    setState(() {});
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  final cf = AppUtil.instance.config;
  final controller = TextEditingController();
  bool isChanged = false;

  void savePath() async {
    await cf.putAndWriteAll(appDatabseCustomPathKey, controller.text);
    await DuDB.instance.changePath(controller.text);
    if (!mounted) return;
    showSnackbar(context, 'Saved');
  }

  @override
  Widget build(BuildContext context) {
    final enable = cf.getBool(appDatabseCustomPathEnableKey);
    return Column(
      spacing: 8,
      children: [
        SwitchListTile.adaptive(
          title: Text('Custom Database Path'),
          value: enable,
          onChanged: (value) {
            cf.putAndWriteAll(appDatabseCustomPathEnableKey, value);
          },
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
    );
  }
}
