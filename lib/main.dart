import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './providers/auth.dart';
import './screens/login_screen.dart';
import './screens/sign_up_screen.dart';
import './screens/welcome_screen.dart';
import './screens/mainpage_screen.dart';

import './components/background_with_footers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Life and Success',
        theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.black,
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.black,
              textTheme: ButtonTextTheme.primary,
            ),
            textTheme: Theme.of(context).textTheme.copyWith(
                  title: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  body1: TextStyle(
                    fontSize: 12,
                  ),
                )),
        // darkTheme: ThemeData.dark(),
        home: Checker(),
        routes: {
          WelcomeScreen.routeName: (_) => WelcomeScreen(),
          RecoverPasswordScreen.routeName: (_)=> RecoverPasswordScreen(),
          MainpageScreen.routeName:(_)=>MainpageScreen(),
        },
      ),
    );
  }
}

class Checker extends StatelessWidget {
  const Checker({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: Provider.of<Auth>(context).getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('An error occured!'));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data == null) {
          return MyHomePage();
        }
        return MainpageScreen();
      },
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
                  ),
                  Tab(text: 'SIGNUP')
                ],
                labelColor: Theme.of(context).accentColor,
              ),
            ),
            body: TabBarView(children: <Widget>[
              LoginScreen(),
              SignupScreen(),
            ])),
      ),
    );
  }
}
