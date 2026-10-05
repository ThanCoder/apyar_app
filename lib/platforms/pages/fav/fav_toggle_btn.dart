import 'package:apyar_app/core/controllers/i_controller.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/platforms/pages/fav/fav_controller.dart';
import 'package:flutter/material.dart';

class FavToggleBtn extends StatefulWidget {
  const new({super.key, required this.apyar});
  final Apyar apyar;

  @override
  State<FavToggleBtn> createState() => _FavToggleBtnState();
}

class _FavToggleBtnState extends State<FavToggleBtn> {
  final con = ControllerManager.read<FavController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: con.events.whereType<FavLoaded>(),
      builder: (context, asyncSnapshot) {
        final id = widget.apyar.generatedId.toString();
        final exists = con.exists(id);
        return IconButton(
          onPressed: () {
            if (exists) {
              con.remove(id);
            } else {
              con.add(id);
            }
          },
          icon: Icon(exists ? Icons.favorite : Icons.favorite_outline),
        );
      },
    );
  }
}
