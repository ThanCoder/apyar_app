import 'package:apyar_app/core/utils/app_util.dart';
import 'package:apyar_app/keys.dart';
import 'package:flutter/material.dart';

class ReaderConfigMenu extends StatefulWidget {
  const new({super.key});

  @override
  State<ReaderConfigMenu> createState() => _ReaderConfigMenuState();
}

class _ReaderConfigMenuState extends State<ReaderConfigMenu> {
  final cf = AppUtil.instance.config;
  final fonts = [10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24];
  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: [
            ListTile(title: Text('Reader Config')),
            Container(
              padding: .symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: col.surfaceContainer,
                borderRadius: .circular(14),
              ),
              child: Row(
                children: [
                  Text(
                    'FontSize',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: .w600,
                      color: col.onSurface,
                    ),
                  ),
                  Spacer(),
                  StreamBuilder(
                    stream: cf.stream.put.where(
                      (e) => e.key == textReaderFontSizekey,
                    ),
                    builder: (context, asyncSnapshot) {
                      return DropdownButton<int>(
                        padding: .all(10),
                        borderRadius: .circular(14),
                        value: cf.getDouble(textReaderFontSizekey, 18).toInt(),
                        items: [
                          for (final f in fonts)
                            DropdownMenuItem(
                              value: f,
                              child: Text(f.toString()),
                            ),
                        ],
                        onChanged: (value) {
                          cf.putAndWriteAll(
                            textReaderFontSizekey,
                            value?.toDouble(),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
