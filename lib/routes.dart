import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/platforms/pages/desktop_reader_page.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

Future<void> goContentPage(BuildContext context,Apyar apyar)async{
   await context.pushMaterialPageRoute(
          builder: (mainCtx) => DesktopReaderPage(apyar: apyar),
        );
}