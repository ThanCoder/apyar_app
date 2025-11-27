import 'package:flutter/material.dart';
import 'package:thancoder_pre_app/app/ui/home/home_page.dart';
import 'package:thancoder_pre_app/app/ui/home/more_app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final list = [HomePage(), MoreApp()];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: 'More',
            icon: Icon(Icons.grid_view_rounded),
          ),
        ],
      ),
    );
  }
}
