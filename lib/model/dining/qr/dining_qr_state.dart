import '../menu.dart';

abstract class DiningQrState {}
class ScanningQrState extends DiningQrState {}
class InvalidQrState extends DiningQrState {
  InvalidQrState(this.reason);

  final String reason;
}
class MealLoadedState extends DiningQrState {
  MealLoadedState(this.meal);

  final Meal meal;
}