import 'package:flutter/material.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import './explore_screen.dart';
import './music_screen.dart';
import './home_screen.dart';
import './planner_screen.dart';
import './profile_screen.dart';

int value = 0;

class MainpageScreen extends StatefulWidget {
  static const routeName = '/main';
  int getPage() {
    return value;
  }

  void setPage(int page) {
    value = page;
  }

  @override
  _MainpageScreenState createState() => _MainpageScreenState();
}

class _MainpageScreenState extends State<MainpageScreen> {
  static PageController _pageController;
  static String payloa;
  List<Widget> pages = [
    HomeScreen(
      gridClickHandle: gridItemClickHandle,
    ),
    ExplorerScreen(payload: payloa),
    MusicScreen(),
    PlannerScreen(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    _pageController = PageController(
      keepPage: true,
      initialPage: widget.getPage(),
    );
    super.initState();
  }

  static void gridItemClickHandle({String payload, bool isExplorer}) {
    payloa = payload;
    if (isExplorer) {
      _pageController.animateToPage(1,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          itemCount: 5,
          onPageChanged: (index) => setState(() {
            widget.setPage(index);
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          itemBuilder: (ctx, index) => pages[index],
          controller: _pageController,
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
          selectedIndex: widget.getPage(),
          items: [
            BottomNavyBarItem(
              activeColor: Theme.of(context).accentColor,
              title: Text('Home'),
              icon: Icon(Icons.web),
            ),
            BottomNavyBarItem(
              activeColor: Theme.of(context).accentColor,
              title: Text('Explore'),
              icon: Icon(Icons.search),
            ),
            BottomNavyBarItem(
              activeColor: Theme.of(context).accentColor,
              title: Text('Music'),
              icon: Icon(Icons.library_music),
            ),
            BottomNavyBarItem(
              activeColor: Theme.of(context).accentColor,
              title: Text('Planner'),
              icon: Icon(Icons.av_timer),
            ),
            BottomNavyBarItem(
              activeColor: Theme.of(context).accentColor,
              title: Text('Profile'),
              icon: Icon(Icons.person),
            ),
          ],
          onItemSelected: (index) => setState(() {
                widget.setPage(index);
                _pageController.jumpToPage(index);
              })),
    );
  }
}
