import 'package:flutter/material.dart';

class DiningScreen extends StatelessWidget {
  const DiningScreen({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF424242),
      body: Center(
        child: Text('Dining route'),
      ),
    );
  }
}
