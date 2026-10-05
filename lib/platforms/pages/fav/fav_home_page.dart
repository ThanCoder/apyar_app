import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/platforms/pages/fav/fav_controller.dart';
import 'package:apyar_app/platforms/pages/fav/fav_toggle_btn.dart';
import 'package:apyar_app/routes.dart';
import 'package:flutter/material.dart';
import 'package:apyar_app/core/controllers/i_controller.dart';

class FavHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<FavHomePage> createState() => _FavHomePageState();
}

class _FavHomePageState extends State<FavHomePage> {
  final con = ControllerManager.read<FavController>();

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourite')),
      body: StreamBuilder(
        stream: con.events.whereType<FavLoaded>(),
        builder: (context, asyncSnapshot) {
          return _body;
        },
      ),
    );
  }

  Widget get _body {
    if (con.apyarList.isEmpty) {}

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 5),
      itemCount: con.apyarList.length,
      itemBuilder: (context, index) => _listItem(con.apyarList[index]),
    );
  }

  int? currentId;
  Widget _listItem(Apyar apyar) {
    return ListTile(
      tileColor: currentId == apyar.generatedId
          ? col.primaryContainer
          : col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      // leading: Icon(Icons.favorite_outline),
      title: Text(
        apyar.title,
        style: TextStyle(color: col.onSurface, fontWeight: .w600, fontSize: 14),
      ),
      leading: FavToggleBtn(apyar: apyar),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: col.onSurfaceVariant,
      ),
      onTap: () async {
        currentId = apyar.generatedId;
        await goContentPage(context, apyar);
        setState(() {});
      },
    );
  }
}
