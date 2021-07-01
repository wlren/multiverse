//Packages
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Local Files
import '../model/green_pass_model.dart';

class GreenPassScreen extends StatefulWidget {
  const GreenPassScreen({Key? key}) : super(key: key);

  @override
  _GreenPassScreenState createState() => _GreenPassScreenState();
}

class _GreenPassScreenState extends State<GreenPassScreen> {
  final secondsLeftStream =
      Stream.periodic(const Duration(seconds: 1), (value) => 119 - value)
          .takeWhile((secondsLeft) => secondsLeft >= 0);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: 120,
      stream: secondsLeftStream,
      builder: (context, snapshot) {
        final secondsLeft = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            backwardsCompatibility: false,
            backgroundColor: context.getBackgroundColor(secondsLeft),
            elevation: 0,
          ),
          body: Container(
            color: context.getBackgroundColor(secondsLeft),
            child: Center(
              child: Column(
                children: [
                  _buildIcon(context, secondsLeft),
                  Text(
                    '$secondsLeft',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(BuildContext context, int secondsLeft) {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 1,
            child: FittedBox(
              fit: BoxFit.fill,
              child:
                  context.watch<GreenPassModel>().isPassGreen && secondsLeft > 0
                      ? const Icon(Icons.done)
                      : const Icon(Icons.close),
            ),
          )),
    );
  }
}

extension on BuildContext {
  Color getBackgroundColor(int secondsLeft) {
    return watch<GreenPassModel>().isPassGreen && secondsLeft > 0
        ? (Theme.of(this).brightness == Brightness.light
            ? Colors.green.shade300
            : Colors.green.shade500)
        : (Theme.of(this).brightness == Brightness.light
            ? Colors.red.shade300
            : Colors.red.shade500);
  }
}
