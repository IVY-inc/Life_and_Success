import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:life_and_success/data/db.dart';
import 'package:life_and_success/helper/notification_helper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './providers/auth.dart';
import './providers/goal.dart';
import './screens/login_screen.dart';
import './screens/sign_up_screen.dart';
import './screens/welcome_screen.dart';
import './screens/explore_screen.dart';
import './screens/mainpage_screen.dart';
import './screens/profile/edit_profile_screen.dart';
import './screens/explore/goals/goal_planner_screen.dart';

import './components/background_with_footers.dart';

MyDatabase db;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

bool launchedFromNotification = false;
String notificationPayload;

Future<void> main() async {
  db = MyDatabase();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    launchedFromNotification = (await flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails())
        .didNotificationLaunchApp;
    var initializationSettingsAndroid = AndroidInitializationSettings('icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
      didReceiveLocalNotifSubject.add(NotificationClass(
          id: id, title: title, body: body, payload: payload));
    });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('Intialised with payload: ${payload ?? 'null'}');
        notificationPayload = payload;
        // if it is a planner completed notif, mark the todo as done
        // and continue
        final data = jsonDecode(payload);
        if (data['type'] == PLANNER_COMPLETED) {
          var todo = await db.getTodoWithId(data['id'] as int);
          todo = todo.copyWith(done: true);
          await db.updateTodo(todo);
        }
        selectNotifSubject.add(payload);
      }
    });
  } catch (e) {
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => Auth(),
        //added ChangeNotifierProxyProvider to pass authentication [user] to goal provider as we
        //need it to add and delete goals
        child: ChangeNotifierProxyProvider<Auth, Goal>(
          update: (ctx, auth, oldGoal) => Goal(auth.user),
          child: Provider<MyDatabase>(
            create: (_) => db,
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
                        headline6: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        bodyText2: TextStyle(
                          fontSize: 12,
                        ),
                      )),
              // darkTheme: ThemeData.dark(),
              home: Checker(),
              routes: {
                WelcomeScreen.routeName: (_) => WelcomeScreen(),
                RecoverPasswordScreen.routeName: (_) => RecoverPasswordScreen(),
                MainpageScreen.routeName: (_) => MainpageScreen(),
                ExplorerScreen.routeName: (_) => ExplorerScreen(),
                GoalPlannerScreen.routeName: (_) => GoalPlannerScreen(),
                EditProfileScreen.routeName: (_) => EditProfileScreen(),
              },
            ),
          ),
        ));
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
        return MainpageScreen(nPayload: notificationPayload);
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
            resizeToAvoidBottomInset: true,
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
