import 'package:flutter/material.dart';


class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('활동'),
        centerTitle: true,
      ),
      body: Center(
        child: const Text('활동 내용'),
      ),
    );
  }
}
