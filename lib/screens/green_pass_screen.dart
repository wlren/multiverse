import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/green_pass_model.dart';
import '../view_model/user_model.dart';

class GreenPassScreen extends StatelessWidget {
  const GreenPassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GreenPassModel>(
      create: (context) => GreenPassModel(userModel: context.read<UserModel>()),
      builder: (context, _) => Scaffold(
        body: Container(
          color: _getBackgroundColor(context),
          child: const Center(
            child: Text('Green Pass Screen!'),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    return context.watch<GreenPassModel>().isPassGreen ?
      Colors.green.shade300 : Colors.red.shade300;
  }
}
