import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class EachBookGrid extends StatelessWidget {
  final String title;
  EachBookGrid(this.title);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(child: Image.asset('assets/images/books.png')),
        Container(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 30,
            ),
            child: AutoSizeText(
              title,
              maxLines: 2,
            ),
          ),
        )
        //Text(title),
      ],
    );
  }
}
