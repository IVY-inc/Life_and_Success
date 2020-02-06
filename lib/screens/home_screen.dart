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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  SliverPersistentHeader makeHeader(String headerTitle, int val) {
    double offset = 0.0;
    for (int i = 0; i < val; i++) {
      if (i == 0) {
        offset += 360;
      } else
        offset += 238;
    }
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverTitleDelegate(
        maxHeight: 30,
        minHeight: 20,
        child: GestureDetector(
          onTap: () => _scrollController.animateTo(offset,
              duration: Duration(milliseconds: 300), curve: Curves.ease),
          child: Container(
            color: Colors.white,
            child: Text(
              headerTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              title: Text('Life and Success'),
              pinned: true,
            ),
            for (int i = 0; i < sections.length; i++) ...[
              makeHeader(sections[i], i),
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
              SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
