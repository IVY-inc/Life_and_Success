import 'package:flutter/material.dart';

class WelcomeWidget0 extends StatelessWidget {
  //height for the image container
  final double height;
  WelcomeWidget0(this.height);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(height: height),
                Image.asset('assets/images/welcome0.png',
                    width: 200, height: 200),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Track your Activity',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
            Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  'Lorem ipsum dolor sit amet,'
                  'consetetur sadipscing elitr, sed diam nonumy eirmod'
                  ' tempor invidunt ut labore et dolore magna aliquyam erat,'
                  ' sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum',
                  maxLines: 4,
                  //style: Theme.of(context).textTheme.body1,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.justify,
                )),
          ],
        ),
      ),
    );
  }
}
