import 'package:apyar_app/bloc_app/cubits/apyar_bookmark_list_cubit.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_widgets/t_widgets.dart';

class BookmarkToggleWidget extends StatelessWidget {
  final Apyar apyar;
  const BookmarkToggleWidget({super.key, required this.apyar});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApyarBookmarkListCubit, ApyarBookmarkListCubitState>(
      builder: (context, state) {
        if (state.isLoading) {
          return SizedBox(width: 25, height: 25, child: TLoader(size: 25));
        }
        final exists = context.read<ApyarBookmarkListCubit>().exists(apyar);
        return IconButton(
          onPressed: () {
            context.read<ApyarBookmarkListCubit>().toggle(apyar);
          },
          icon: Icon(
            color: exists ? Colors.red : Colors.blue,
            exists ? Icons.bookmark_remove : Icons.bookmark_add,
          ),
        );
      },
    );
  }
}
