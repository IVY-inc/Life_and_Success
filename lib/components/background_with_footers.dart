import 'package:flutter/material.dart';

class BackgroundWithFooter extends StatelessWidget {
  ///BackgroundWithFooter class created to wrap the footer images with a [Scaffold]
  ///
  //args : [child]
  ///BackgroundWithFooter(child: Scaffold(...))

  final Widget child;
  BackgroundWithFooter({this.child});
  @override
  Widget build(BuildContext context) {
    final leftImage =
        Image.asset('assets/images/footer_left.png', width: 120, height: 120);
    final rightImage =
        Image.asset('assets/images/footer_right.png', width: 150, height: 150);
    
    return Stack(
      children: <Widget>[
        child,
        Positioned(
          bottom: -20,
          left: -28,
          child: leftImage,
        ),
        Positioned(
          bottom: -30,
          right: -75,
          child: rightImage,
        ),
      ],
    );
  }
}
