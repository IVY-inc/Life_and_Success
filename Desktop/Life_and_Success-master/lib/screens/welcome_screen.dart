import 'package:flutter/material.dart';

import './mainpage_screen.dart';
import '../components/welcome_widgets/welcome_widget_0.dart';
import '../components/welcome_widgets/welcome_widget_1.dart';
import '../components/welcome_widgets/welcome_widget_2.dart';
import '../components/background_with_footers.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentPage = 0;
  PageController _pageController;
  @override
  void initState() {
    _pageController =PageController(
      initialPage: 0,
      keepPage: true,
    );
    super.initState();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    //Height of the container occupied by the image which is half of the screen
    final imageSize = mediaquery.size.height / 2;

    ///called when [icon] arrow_back is pressed on screens 1 and 2
    void _movePageBackwards() {
      if (_currentPage != 0) {
        _currentPage--;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 150),
          curve: Curves.linear,
        );
      }
    }

    ///[Three welcome screens].. stored in the widgets directory..[imageSize, _movePageBackwards]
    ///imageSize: Half of the screen where the image will sit upon
    ///_movePageBackwards: passed to the AppBar leading iconButton to go back one page
    final _welcomeScreens = [
      WelcomeWidget0(imageSize),
      WelcomeWidget1(imageSize, _movePageBackwards),
      WelcomeWidget2(imageSize, _movePageBackwards),
    ];

    //onPageChanged
    void _pageScrolled(int page) {
      setState(() {
        _currentPage = page;
      });
    }

    ///{Button} [CONTINUE] clicked
    void _movePageForward() {
      if (_currentPage != 2) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          curve: Curves.linear,
          duration: Duration(milliseconds: 150),
        );
      } else {
        Navigator.of(context).popAndPushNamed(MainpageScreen.routeName);
      }
    }

    //Builder widgets for the navigation indicators
    Widget circleBar(int i) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: 8,
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 8,
        decoration: BoxDecoration(
          color: _currentPage == i ? Colors.black : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    //page Builder.. main Widget**********************
    final page = BackgroundWithFooter(
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (ctx, index) => _welcomeScreens[index],
        itemCount: _welcomeScreens.length,
        onPageChanged: (page) => _pageScrolled(page),
      ),
    );

    //return Value
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        page,
        Positioned(
            bottom: 150,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[for (int i = 0; i < 3; i++) circleBar(i)],
            )),
        Positioned(
          bottom: 70,
          child: RaisedButton(
            onPressed: _movePageForward,
            child: Text(_currentPage == _welcomeScreens.length - 1
                ? 'GET STARTED'
                : 'CONTINUE'),
          ),
        ),
      ],
    );
  }
}
