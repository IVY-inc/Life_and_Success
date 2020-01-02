import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './screens/sign_up_screen.dart';

import './widgets/background_with_footers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Life and Success',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.black,
          textTheme: ButtonTextTheme.primary,
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: BackgroundWithFooter(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Life and Success'),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: 'LOGIN',
                  ),Tab(
                    text: 'SIGNUP'
                  )
                ],
                labelColor: Theme.of(context).accentColor,
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                LoginScreen(),
                SignupScreen(),
              ] 
            )
            ),
      ),
    );
  }
}
