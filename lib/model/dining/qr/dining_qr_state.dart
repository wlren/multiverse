import '../menu.dart';

abstract class DiningQrState {}
class ScanningQrState extends DiningQrState {}
abstract class InvalidQrState extends DiningQrState {
  InvalidQrState(this.reason);

  final String reason;
}

class MealNotFoundState extends InvalidQrState {
  MealNotFoundState() : super('QR code does not correspond to a meal');
}

class InvalidQrFormatState extends InvalidQrState {
  InvalidQrFormatState() : super('QR code scanned is invalid');
}

class MealLoadedState extends DiningQrState {
  MealLoadedState(this.meal);

  final Meal meal;
}