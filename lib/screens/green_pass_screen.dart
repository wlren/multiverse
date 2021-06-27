//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Local Files
import '../model/green_pass_model.dart';

class GreenPassScreen extends StatelessWidget {
  const GreenPassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        backgroundColor: _getBackgroundColor(context),
      ),
      body: Container(
        color: _getBackgroundColor(context),
        child: const Center(
          child: Text('Green Pass Screen!'),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    return context.watch<GreenPassModel>().isPassGreen
        ? (Theme.of(context).brightness == Brightness.light
            ? Colors.green.shade300
            : Colors.green.shade500)
        : (Theme.of(context).brightness == Brightness.light
            ? Colors.red.shade300
            : Colors.red.shade500);
  }
}
