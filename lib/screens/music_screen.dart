import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/constants.dart';
//stub data.. TODO: replace with real data

List<SubMusicSection> motivs = [
  SubMusicSection(
    musicCount: 40,
    musicSubTitle: 'School',
  ),
  SubMusicSection(
    musicCount: 20,
    musicSubTitle: 'Work and Productivity',
  ),
  SubMusicSection(
    musicCount: 35,
    musicSubTitle: 'Goals',
  ),
  SubMusicSection(
    musicCount: 40,
    musicSubTitle: 'Sports',
  ),
  SubMusicSection(
    musicCount: 20,
    musicSubTitle: 'General',
  )
];
List<SubMusicSection> binaura = [
  SubMusicSection(
    musicCount: 40,
    musicSubTitle: 'Meditation',
  ),
  SubMusicSection(
    musicCount: 20,
    musicSubTitle: 'Sleep',
  ),
  SubMusicSection(
    musicCount: 35,
    musicSubTitle: 'Relaxation and Rest',
  ),
  SubMusicSection(
    musicCount: 40,
    musicSubTitle: 'Inner peace and self discovery',
  )
];

class MusicScreen extends StatelessWidget {
  final motivationals = motivs
      .map((e) => Container(
        width: 105,
        child: Column(children: [
              Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12))),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Text(e.title,
                  
                      style: TextStyle(
                        
                        fontWeight: FontWeight.bold,
                      )),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Text(e.subtitle,)),
            ]),
      ))
      .toList();
  final binaurals = binaura
      .map((e) => Container(
        width:105,
        child: Column(children: [
              Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12))),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Text(e.title,
                  
                      style: TextStyle(
                        
                        fontWeight: FontWeight.bold,
                      )),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Text(e.subtitle,)),
            ]),
      ))
      .toList();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Music'),
        actions: <Widget>[
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
            padding: EdgeInsets.all(8),
            child: Icon(CupertinoIcons.search),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(height * 0.3),
              SizedBox(height: 20),
              Text('Motivational Audio'),
              SizedBox(height: 20),
              Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: motivationals,
                ),
              ),
              SizedBox(height: 20),
              Text('Binaural beats'),
              SizedBox(height: 20),
              Container(
                height: 150,
                child: ListView(
                  
                  scrollDirection: Axis.horizontal,
                  children: binaurals,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  final double height;
  Card(this.height);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(12)),
        height: height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.queue_music, size: 40, color: Colors.white),
            Text(
              'List of Popular Songs',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Lorem ipsum dolor sit amet consectetur adipiscing elit',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}
