import 'package:apyar_app/app/ui/components/bookmark_toggle_widget.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:flutter/material.dart';

class ApyarListItem extends StatelessWidget {
  final Apyar apyar;
  final void Function(Apyar apyar) onClicked;
  final void Function(Apyar apyar)? onRightClicked;
  const ApyarListItem({super.key,required this.apyar,required this.onClicked,this.onRightClicked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onSecondaryTap: () => onRightClicked?.call(apyar),
      child: ListTile(
        title: Text(apyar.title),
        trailing: BookmarkToggleWidget(apyar: apyar),
        onTap: () => onClicked(apyar)),
    );
  }
}