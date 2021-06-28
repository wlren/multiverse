import 'package:bloc/bloc.dart';

import '../menu.dart';
import 'dining_qr_data.dart';
import 'dining_qr_event.dart';
import 'dining_qr_state.dart';

class DiningQrBloc extends Bloc<DiningQrEvent, DiningQrState> {
  DiningQrBloc(this.currentMenu) : super(ScanningQrState());

  final Menu currentMenu;

  @override
  Stream<DiningQrState> mapEventToState(DiningQrEvent event) async* {
    if (event is ValidQrScannedEvent) {
      final scannedMeal = event.data.getMealFromMenu(currentMenu);
      if (scannedMeal != null) {
        yield MealLoadedState(scannedMeal);
      } else {
        yield MealNotFoundState();
      }
    } else if (event is QrRetryEvent) {
      yield ScanningQrState();
    } else if (event is InvalidFormatQrScannedEvent) {
      yield InvalidQrFormatState();
    }
  }
}

extension on DiningQrData {
  Meal? getMealFromMenu(Menu menu) {
    return menu.getMealByCuisineId(cuisineId);
  }
}
