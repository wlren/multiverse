import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:multiverse/model/temperature/temperature_model.dart';
import 'package:multiverse/model/temperature/temperature_state.dart';
import 'package:multiverse/screens/temperature_screen.dart';
import 'package:provider/provider.dart';

import 'temperature_screen_test.mocks.dart';

@GenerateMocks([TemperatureModel])
void main() {
  testWidgets('Declare button declares a temperature record', (tester) async {
    final mockTemperatureModel = MockTemperatureModel();
    when(mockTemperatureModel.declareTemperature(any, any))
        .thenAnswer((_) async {});
    when(mockTemperatureModel.temperatureState)
        .thenReturn(TemperatureState.undeclared);
    when(mockTemperatureModel.temperatureRecords).thenAnswer((_) => []);

    await tester.pumpWidget(ChangeNotifierProvider<TemperatureModel>(
      create: (context) => mockTemperatureModel,
      child: const MaterialApp(home: TemperatureScreen()),
    ));

    final formCheckboxes = find.byType(Checkbox);
    expect(find.byType(Checkbox), findsNWidgets(2));
    await tester.tap(formCheckboxes.at(0));
    await tester.tap(formCheckboxes.at(1));

    final slider = find.byType(Slider);
    expect(slider, findsOneWidget);

    await tester.tapAt(tester.getTopLeft(slider));

    final declareButton = find.text('Declare');
    expect(declareButton, findsOneWidget);
    await tester.tap(declareButton);
    await tester.pumpAndSettle();

    final snackBar = find.byType(SnackBar);
    expect(snackBar, findsOneWidget);
    expect(
        find.descendant(
            of: snackBar, matching: find.text('Temperature declared')),
        findsOneWidget);
  });
}
