import 'package:flutter/material.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import './explore_screen.dart';
import './music_screen.dart';
import './home_screen.dart';
import './planner_screen.dart';
import './profile_screen.dart';

int value = 0;

class MainpageScreen extends StatefulWidget {
  static String notificationPayload;
  MainpageScreen({String nPayload}) {
    if (nPayload != null) {
      notificationPayload = nPayload;
    }
  }

  static const routeName = '/main';
  int getPage() {
    if(notificationPayload!=null)return 1;
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
  List<Widget> pages;
  Widget getExplorer() {
    if (MainpageScreen.notificationPayload != null) {
      String np = MainpageScreen.notificationPayload;
      //payload reset to null
      MainpageScreen.notificationPayload = null;
      
      return ExplorerScreen(
        explorerRoute: payloa,
        back: itemClickHandle,
        notificationPayload: np,
      );
    }
    return ExplorerScreen(explorerRoute: payloa, back: itemClickHandle);
  }

  @override
  void initState() {
    _pageController = PageController(
      keepPage: true,
      initialPage: widget.getPage(),
    );
    pages = [
      HomeScreen(
        gridClickHandle: itemClickHandle,
      ),
      getExplorer(),
      MusicScreen(back: itemClickHandle),
      PlannerScreen(back: itemClickHandle),
      ProfileScreen(),
    ];
    super.initState();
  }

  ///Item Click Handle function that handles
  ///[isExplorer] if it shows in the explore section of the app
  ///e.g. the GoalPlannerScreen() shows in the explore section of the app
  ///
  ///[payload] that holds the routeName of the Widget or screen to be passed to the
  ///FavoritesScreen() for now
  ///
  ///[isBackKey] for jumping back to page 1 of the mainPage
  static void itemClickHandle(
      {String payload, bool isExplorer = false, bool isBackKey = false}) {
    //assertion to make sure that VoidCallBack is only responsible for one action at a time
    assert((isExplorer && isBackKey) == false);

    if (payload != null) payloa = payload;
    if (isExplorer) {
      _pageController.animateToPage(1,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
    if (isBackKey && _pageController.page != 0) {
      _pageController.jumpToPage(0);
      //   _pageController.animateToPage(0,
      //   duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          itemCount: 5,
          onPageChanged: (index){
            widget.setPage(index);
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
                setState(() {
                  
                });
          },
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
