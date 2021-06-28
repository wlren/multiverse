import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../model/dining/menu.dart';
import '../model/dining/redeem/dining_redeem_bloc.dart';
import '../model/dining/redeem/dining_redeem_event.dart';
import '../model/dining/redeem/dining_redeem_form_model.dart';
import '../model/dining/redeem/dining_redeem_state.dart';
import '../repository/dining_repository.dart';

class DiningRedeemScreen extends StatelessWidget {
  const DiningRedeemScreen(this.meal, {Key? key}) : super(key: key);

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    const maxCredits = 3;
    final diningRepository = context.read<DiningRepository>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => DiningRedeemFormModel(maxCredits)),
        BlocProvider(create: (context) => DiningRedeemBloc(diningRepository)),
      ],
      builder: (context, _) {
        return BlocBuilder<DiningRedeemBloc, DiningRedeemState>(
          builder: (context, state) {
            final formModel = context.watch<DiningRedeemFormModel>();
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backwardsCompatibility: false,
                title: const Text('Meal redemption'),
                automaticallyImplyLeading: state is! SuccessfulRedeemState,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          (state is SuccessfulRedeemState)
                              ? 'You have redeemed: '
                              : 'You selected: ',
                          style: Theme.of(context).textTheme.headline6),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        // stretch horizontally
                        width: double.infinity,
                        child: _buildCard(
                            redeemed: state is SuccessfulRedeemState),
                      ),
                      if (state is UnredeemedState) ...{
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        vertical: 16.0))),
                            onPressed: () => _onRedeemPressed(context),
                            icon: const Icon(Icons.done),
                            label: Text('Redeem ${formModel.mealCount}'),
                          ),
                        ),
                      } else if (state is PendingRedeemState) ...{
                        const CircularProgressIndicator(),
                      } else if (state is SuccessfulRedeemState) ...{
                        ElevatedButton.icon(
                          onPressed: () => _onFinishPressed(context),
                          icon: const Icon(Icons.done_all),
                          label: const Text('Finish'),
                        ),
                      }
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCard({required bool redeemed}) {
    return Builder(
      builder: (context) {
        final redeemFormModel = context.read<DiningRedeemFormModel>();
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    redeemed
                        ? '${meal.cuisine.name} x${redeemFormModel.mealCount}'
                        : meal.cuisine.name,
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 16.0),
                for (MealItem mealItem in meal.mealItems) ...{
                  Text(
                    mealItem.name,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          height: 1.5,
                        ),
                  ),
                  if (mealItem != meal.mealItems.last) const Divider(),
                },
                const SizedBox(height: 8.0),
                if (!redeemed) ...{
                  const SizedBox(height: 8.0),
                  const Divider(
                    thickness: 2.0,
                    height: 32.0,
                  ),
                  Row(
                    children: [
                      Text('Amount',
                          style: Theme.of(context).textTheme.subtitle1),
                      const Spacer(),
                      IconButton(
                        onPressed: redeemFormModel.canPressMinus
                            ? redeemFormModel.onMinusPressed
                            : null,
                        icon: const Icon(Icons.remove_circle),
                      ),
                      Text(
                        context
                            .watch<DiningRedeemFormModel>()
                            .mealCount
                            .toString(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      IconButton(
                        onPressed: redeemFormModel.canPressPlus
                            ? redeemFormModel.onPlusPressed
                            : null,
                        icon: const Icon(Icons.add_circle),
                      ),
                    ],
                  ),
                },
              ],
            ),
          ),
        );
      },
    );
  }

  void _onRedeemPressed(BuildContext context) async {
    final diningMealModel = context.read<DiningRedeemFormModel>();
    final redeemFormBloc = context.read<DiningRedeemBloc>();
    redeemFormBloc.add(TryRedeemEvent(meal, diningMealModel.mealCount));
  }

  void _onFinishPressed(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }
}
