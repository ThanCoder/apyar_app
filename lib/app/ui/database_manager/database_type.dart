import 'package:apyar_app/bloc_app/cubits/apyar_list_cubit.dart';
import 'package:apyar_app/core/interfaces/db/database_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_widgets/t_widgets.dart';

class DatabaseType extends StatefulWidget {
  final void Function() callInit;
  const DatabaseType({super.key, required this.callInit});

  @override
  State<DatabaseType> createState() => _DatabaseTypeState();
}

class _DatabaseTypeState extends State<DatabaseType> {
  final list = ApyarDBType.values;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Row(
              children: [
                Text('Database Types: '),
                Text(
                  DatabaseInterface.getDBType().name.toUpperCase(),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            DropdownButton<ApyarDBType>(
              borderRadius: BorderRadius.circular(4),
              padding: EdgeInsets.all(4),
              value: DatabaseInterface.getDBType(),
              items: list
                  .map(
                    (e) => DropdownMenuItem<ApyarDBType>(
                      value: e,
                      child: Text(e.name.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: _setValue,
            ),
          ],
        ),
      ),
    );
  }

  void _setValue(ApyarDBType? value) async {
    try {
      if (value == null) return;
      await DatabaseInterface.setDBType(value);
      widget.callInit();

      if (!mounted) return;
      setState(() {});
      showTSnackBar(
        context,
        '`${value.name.toUpperCase()}` ကို Database ပြောင်းလဲလိုက်ပါပြီ။',
      );
      context.read<ApyarListCubit>().init();
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
    }
  }
}
