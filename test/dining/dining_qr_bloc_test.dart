import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiverse/model/dining/qr/dining_qr_bloc.dart';
import 'package:multiverse/model/dining/qr/dining_qr_data.dart';
import 'package:multiverse/model/dining/qr/dining_qr_event.dart';
import 'package:multiverse/model/dining/qr/dining_qr_state.dart';

import '../mocks/menu.dart';

// ignore: non_constant_identifier_names
DiningQrBloc DiningQrBlocWithSampleMenu() =>
    DiningQrBloc(sampleMenu.breakfast!);

void main() {
  group('DiningQrBloc', () {
    blocTest<DiningQrBloc, DiningQrState>(
      'emits [] when nothing is added',
      build: () => DiningQrBlocWithSampleMenu(),
      expect: () => [],
    );

    blocTest<DiningQrBloc, DiningQrState>(
      'emits [MealLoadedState] when valid QR is scanned',
      build: () => DiningQrBlocWithSampleMenu(),
      act: (bloc) => bloc.add(ValidQrScannedEvent(DiningQrData(1))),
      expect: () => [
        isA<MealLoadedState>()
            .having((state) => state.meal, 'meal', equals(sampleMenu.breakfast!.meals.singleWhere((meal) => meal.cuisine.id == 1)))
      ],
    );

    blocTest<DiningQrBloc, DiningQrState>(
      'emits [QrScanningState] when retry is requested',
      build: () => DiningQrBlocWithSampleMenu(),
      act: (bloc) => bloc.add(QrRetryEvent()),
      expect: () => [isA<ScanningQrState>()],
    );

    blocTest<DiningQrBloc, DiningQrState>(
      'emits [InvalidQrState] when invalid QR (wrong content format) is scanned',
      build: () => DiningQrBlocWithSampleMenu(),
      act: (bloc) => bloc.add(InvalidFormatQrScannedEvent()),
      expect: () => [isA<InvalidQrFormatState>()],
    );

    blocTest<DiningQrBloc, DiningQrState>(
      'emits [MealNotFoundState] when valid QR with invalid cuisine id is scanned',
      build: () => DiningQrBlocWithSampleMenu(),
      act: (bloc) => bloc.add(ValidQrScannedEvent(DiningQrData(10))),
      expect: () => [isA<MealNotFoundState>()],
    );
  });
}
