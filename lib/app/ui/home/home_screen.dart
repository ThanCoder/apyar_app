import 'package:apyar_app/app/ui/home/bookmark_page.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_home_page.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:flutter/material.dart';
import 'package:apyar_app/app/ui/home/home_page.dart';
import 'package:apyar_app/app/ui/home/more_app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          HomePage(),
          BookmarkPage(),
          FetcherHomePage(),
          MoreApp(key: ValueKey(index == 1)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blue,
        unselectedItemColor: context.isBrightnessDark
            ? Colors.white
            : Colors.black,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: 'BookMark',
            icon: Icon(Icons.bookmark),
          ),
          BottomNavigationBarItem(label: 'Fetcher', icon: Icon(Icons.book)),
          BottomNavigationBarItem(
            label: 'More',
            icon: Icon(Icons.grid_view_rounded),
          ),
        ],
      ),
    );
  }
}
