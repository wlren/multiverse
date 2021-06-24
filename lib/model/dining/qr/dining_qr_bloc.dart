import 'package:flutter_bloc/flutter_bloc.dart';

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
        yield ScanningQrState();
      } else {
        yield InvalidQrState('Invalid');
      }
    } else if (event is QrRetryEvent) {
      yield ScanningQrState();
    }
  }
}

extension on DiningQrData {
  Meal? getMealFromMenu(Menu menu) {
    return menu.getMealByCuisineId(cuisineId);
  }
}



