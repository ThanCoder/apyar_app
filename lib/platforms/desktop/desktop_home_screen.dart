import 'package:apyar_app/platforms/pages/fav/fav_home_page.dart';
import 'package:apyar_app/platforms/pages/more_page.dart';
import 'package:apyar_app/platforms/desktop/desktop_home_page.dart';
import 'package:apyar_app/platforms/pages/search/search_home_page.dart';
import 'package:flutter/material.dart';

class DesktopHomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _navbar(),
        VerticalDivider(),
        Expanded(
          child: IndexedStack(
            index: index,
            children: [
              DesktopHomePage(),
              SearchHomePage(),
              FavHomePage(),
              MorePage(),
            ],
          ),
        ),
      ],
    );
  }

  NavigationRail _navbar() => NavigationRail(
    onDestinationSelected: (value) {
      setState(() {
        index = value;
      });
    },
    selectedIndex: index,
    destinations: [
      .new(icon: Icon(Icons.home), label: Text('Home')),
      .new(icon: Icon(Icons.search_outlined), label: Text('Search')),
      .new(icon: Icon(Icons.favorite_outline), label: Text('Fav')),
      .new(icon: Icon(Icons.grid_view_outlined), label: Text('More')),
    ],
  );
}
