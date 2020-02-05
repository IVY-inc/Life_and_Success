import 'dart:math';
import 'package:flutter/material.dart';

import '../components/homepage_grid.dart';
import '../models/mainpage_data.dart';

class SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  SliverTitleDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    this.child,
  });

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(
      child: child,
    );
  }

  @override
  bool shouldRebuild(SliverTitleDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class HomeScreen extends StatelessWidget {
  SliverPersistentHeader makeHeader(String headerTitle) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverTitleDelegate(
        maxHeight: 30,
        minHeight: 20,
        child: Container(
          color:Colors.white,
          child: Text(
            headerTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              title: Text('Life and Success'),
              //pinned: true,
              floating: true,
            ),
            for (int i = 0; i < sections.length; i++) ...[
              makeHeader(sections[i]),
              SliverGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: categories[i]
                    .map(
                      (str) => HomepageGrid(
                        text: str,
                      ),
                    )
                    .toList(),
              ),
              SliverList(
                delegate: SliverChildListDelegate([SizedBox(height: 8)]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
