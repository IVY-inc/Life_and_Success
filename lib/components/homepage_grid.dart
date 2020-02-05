import 'package:flutter/material.dart';

class HomepageGrid extends StatelessWidget {
  final String text;
  HomepageGrid({this.text});
  @override
  Widget build(BuildContext context) {
    return GridTile(
        footer: text == null
            ? null
            : Padding(
                padding: EdgeInsets.only(left: 4, right: 8, bottom: 4),
                child: Text(
                  text,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(color: Colors.grey, offset: Offset(4, 4),blurRadius: 4),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-2, -2),
              ),
            ],
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(42, 160, 196, 1),
                Color.fromRGBO(248, 171, 81, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ));
  }
}
