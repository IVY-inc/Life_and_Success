import 'package:flutter/material.dart';
import 'package:life_and_success/screens/explore/books/each_book_grid.dart';
import '../../../models/constants.dart';

class BooksScreen extends StatelessWidget {
  final Function back;
  BooksScreen({this.back});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => back(isBackKey: true),
            ),
            flexibleSpace: FlexibleSpaceBar(
              //titlePadding: EdgeInsets.only(top: 12),
              title: Text('Books'),
              background: Image.asset('assets/images/books.png',
                  width: 200, height: 200, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(child: Text('Lorem Ipsum')),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverGrid.count(
            crossAxisCount: 5,
            children: books.map((e) => EachBookGrid(e)).toList(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 5,
          )
        ],
      ),
    ));
  }
}
