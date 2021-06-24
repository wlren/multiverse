import '../menu.dart';

abstract class DiningRedeemEvent {}
class TryRedeemEvent extends DiningRedeemEvent {
  TryRedeemEvent(this.meal, this.mealCount);

  final Meal meal;
  final int mealCount;
}
class RetryRedeemEvent extends DiningRedeemEvent {}
