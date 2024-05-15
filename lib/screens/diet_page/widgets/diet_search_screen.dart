import 'package:flutter/material.dart';

import 'diet_searchBar.dart';

class DietSearchScreen extends StatefulWidget {
  @override
  _DietSearchScreenState createState() => _DietSearchScreenState();
}

class _DietSearchScreenState extends State<DietSearchScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("식단 검색"),
      ),
      body: CustomSearchbar(),
    );
  }
}