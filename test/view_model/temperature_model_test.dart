import 'package:mockito/annotations.dart';
import 'package:multiverse/model/temperature/temperature_record.dart';
import 'package:multiverse/repository/user_repository.dart';
import 'package:multiverse/model/temperature/temperature_model.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'temperature_model_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  group('Temperature model', () {
    test('update method should fetch data from repository', () async {
      final repository = MockUserRepository();
      var mockTemperatureRecords = <TemperatureRecord>[];
      var isTemperatureDeclared = false;
      const isTemperatureAcceptable = false;

      when(repository.isTemperatureDeclared())
          .thenAnswer((_) async => isTemperatureDeclared);
      when(repository.isTemperatureAcceptable())
          .thenAnswer((_) async => isTemperatureAcceptable);
      when(repository.declareTemperature(any)).thenAnswer((_) async {});
      when(repository.getTemperatureRecords())
          .thenAnswer((_) async => mockTemperatureRecords);

      final temperatureModel = TemperatureModel(repository);

      // Wait for update
      await temperatureModel.update();

      // Expect values to be the same
      expect(temperatureModel.isTemperatureDeclared, false);
      expect(temperatureModel.temperatureRecords, mockTemperatureRecords);

      // Change repository values
      isTemperatureDeclared = true;
      mockTemperatureRecords = [
        TemperatureRecord(time: DateTime.now(), temperature: 34.2),
      ];

      // Wait for update, then verify values
      await temperatureModel.update();
      expect(temperatureModel.isTemperatureDeclared, true);
      expect(temperatureModel.temperatureRecords, mockTemperatureRecords);
    });

    test('declareTemperature should add a TemperatureRecord in repository',
        () async {
      final repository = MockUserRepository();
      final mockTemperatureRecords = <TemperatureRecord>[];
      var isTemperatureDeclared = false;

      // Set up mock interactions
      when(repository.isTemperatureDeclared())
          .thenAnswer((_) async => isTemperatureDeclared);
      when(repository.isTemperatureAcceptable()).thenAnswer((_) async => false);
      when(repository.declareTemperature(any))
          .thenAnswer((realInvocation) async {
        final declaredTemperature =
            realInvocation.positionalArguments.first as double;
        mockTemperatureRecords.add(TemperatureRecord(
            time: DateTime.now(), temperature: declaredTemperature));
        isTemperatureDeclared = true;
      });
      when(repository.getTemperatureRecords())
          .thenAnswer((_) async => mockTemperatureRecords);

      // Declare model and wait for it to be updated
      final temperatureModel = TemperatureModel(repository);
      await temperatureModel.update();

      // Expect temperature to be undeclared
      expect(temperatureModel.isTemperatureDeclared, false);
      expect(temperatureModel.temperatureRecords, []);

      // Declare temperature now
      final temperatureToDeclare = 34.5;
      temperatureModel.declareTemperature(temperatureToDeclare);

      // Wait for model to update
      await temperatureModel.update();

      // Verify that repository method is called
      verify(repository.declareTemperature(temperatureToDeclare));

      expect(temperatureModel.isTemperatureDeclared, true);
      expect(temperatureModel.temperatureRecords, mockTemperatureRecords);
      // verifyNoMoreInteractions(repository);
    });
  });
}
