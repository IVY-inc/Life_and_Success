import 'package:flutter/material.dart';

class WelcomeWidget1 extends StatelessWidget {
  double height;
  final Function back;
  WelcomeWidget1(this.height, this.back);
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 0,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: back),
    );
    height -=
        (MediaQuery.of(context).padding.top + appBar.preferredSize.height);

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(height: height),
              Image.asset('assets/images/welcome1.png',
                  width: 200, height: 200),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Plan to achieve',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.fade,
          ),
          Container(
              margin: EdgeInsets.all(20),
              child: Text(
                'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt',
                maxLines: 4,
                //style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.justify,
              )),
        ],
      ),
    );
  }
}
