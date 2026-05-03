import 'package:apyar_app/app/ui/components/bookmark_toggle_widget.dart';
import 'package:apyar_app/bloc_app/cubits/apyar_list_cubit.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApyarListItem extends StatelessWidget {
  final Apyar apyar;
  final void Function(Apyar apyar) onClicked;
  final void Function(Apyar apyar)? onRightClicked;
  const ApyarListItem({
    super.key,
    required this.apyar,
    required this.onClicked,
    this.onRightClicked,
  });

  @override
  Widget build(BuildContext context) {
    final exists = context.read<ApyarListCubit>().exists(apyar);

    return InkWell(
      mouseCursor: !exists ? null : SystemMouseCursors.click,
      onSecondaryTap: !exists ? null : () => onRightClicked?.call(apyar),
      onLongPress: !exists ? null : () => onRightClicked?.call(apyar),
      child: ListTile(
        title: Text(apyar.title),
        trailing: !exists ? null : BookmarkToggleWidget(apyar: apyar),
        onTap: !exists ? null : () => onClicked(apyar),
      ),
    );
  }
}
