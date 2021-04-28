import 'package:flutter/material.dart';
import 'package:sku_app/views/home/home.dart';
import 'package:sku_app/views/kitchen/kitchen.dart';
import 'package:sku_app/views/reports/reports.dart';
import 'package:sku_app/views/trends/trends.dart';

class TabSwitcher extends StatefulWidget {
  @override
  _TabSwitcherState createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {
  final List<Widget> _children = [
    Home(),
    Trends(),
    Reports(),
    Kitchen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _children.length,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("Smart Kitchen Unit"),
        // ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: "Trends",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: "Reports",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: "Kitchen",
            ),
          ],
        ),
        // title: Text('Home'),
        body: _children[_currentIndex],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
