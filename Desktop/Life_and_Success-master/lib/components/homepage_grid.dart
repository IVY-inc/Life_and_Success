import 'package:flutter/material.dart';

class HomepageGrid extends StatelessWidget {
  final String text;
  final Function gridClickHandle;
  HomepageGrid({this.text, this.gridClickHandle});
  @override
  Widget build(BuildContext context) {
    //Gesture detector added.. error may occur here
    return GestureDetector(
      onTapUp: (_) => gridClickHandle(
          isExplorer: true,
          payload: '/${text.toLowerCase().replaceAll(" ", "")}'),
      child: GridTile(
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
                BoxShadow(
                    color: Colors.grey, offset: Offset(4, 4), blurRadius: 4),
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
          )),
    );
  }
}
