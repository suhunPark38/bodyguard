import 'package:flutter/material.dart';


class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
        centerTitle: true,
      ),
      body: Center(
          child: const Text('Favorite'),
        ),
    );
  }
}
