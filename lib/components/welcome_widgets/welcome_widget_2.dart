import 'package:flutter/material.dart';

class WelcomeWidget2 extends StatelessWidget {
  final double h;
  final Function back;
  WelcomeWidget2(this.h,this.back);
  @override
  Widget build(BuildContext context) {
    double height = h;
    final appBar = AppBar(
      elevation: 0,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: back),
    );

    height -=(MediaQuery.of(context).padding.top+appBar.preferredSize.height);
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(height: height),
              Image.asset('assets/images/welcome2.png',
                  width: 200, height: 200),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Daily insights',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.fade,
          ),
          
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              'Quiere la boca exhausta vid, kiwi, piña y fugaz jamón. Fabio me exige, sin tapujos, que añada cerveza al whisky. Jovencillo emponzoñado de whisky, ¡qué figurota exhibes! La cigüeña tocaba cada vez mejor el',
              maxLines: 4,
              style: Theme.of(context).textTheme.body1,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}
