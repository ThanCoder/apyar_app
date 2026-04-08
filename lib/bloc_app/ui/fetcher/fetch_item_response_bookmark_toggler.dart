import 'package:apyar_app/bloc_app/cubits/fetch_item_response_cubit.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetchItemResponseBookmarkToggler extends StatelessWidget {
  final FetchItemResponse item;
  const FetchItemResponseBookmarkToggler({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchItemResponseCubit, FetchItemResponseCubitState>(
      builder: (context, state) {
        final cubit = context.read<FetchItemResponseCubit>();
        final exists = cubit.isExists(item);
        return IconButton(
          onPressed: () {
            if (exists) {
              cubit.remove(item);
            } else {
              cubit.add(item);
            }
          },
          icon: exists
              ? Icon(Icons.bookmark_remove, color: Colors.red)
              : Icon(Icons.bookmark_add, color: Colors.blue),
        );
      },
    );
  }
}
