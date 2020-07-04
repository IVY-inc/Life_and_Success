import 'package:flutter/material.dart';

class BooksScreen extends StatelessWidget {
  final Function back;
  BooksScreen({this.back});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Books')
    );
  }
}