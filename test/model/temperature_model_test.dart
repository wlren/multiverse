import 'package:mockito/annotations.dart';
import 'package:multiverse/model/temperature/temperature_record.dart';
import 'package:multiverse/model/temperature/temperature_state.dart';
import 'package:multiverse/repository/user_repository.dart';
import 'package:multiverse/model/temperature/temperature_model.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'temperature_model_test.mocks.dart';

@GenerateMocks([],
    customMocks: [MockSpec<UserRepository>(returnNullOnMissingStub: true)])
void main() {
  group('Temperature model', () {
    test('listens to repository changes', () async {
      final mockTemperatureRecords = <TemperatureRecord>[];
      const temperatureState = TemperatureState.undeclared;
      final repository = MockUserRepository();
      when(repository.getTemperatureRecords())
          .thenAnswer((_) async => mockTemperatureRecords);
      when(repository.getTemperatureState())
          .thenAnswer((_) async => temperatureState);
      // ignore: unused_local_variable
      final temperatureModel = TemperatureModel(repository);
      verify(repository.addListener(any));
    });

    test('update method fetches data from repository', () async {
      final repository = MockUserRepository();
      var mockTemperatureRecords = <TemperatureRecord>[];
      var temperatureState = TemperatureState.undeclared;

      when(repository.getTemperatureState())
          .thenAnswer((_) async => temperatureState);
      when(repository.declareTemperature(any)).thenAnswer((_) async {});
      when(repository.getTemperatureRecords())
          .thenAnswer((_) async => mockTemperatureRecords);

      final temperatureModel = TemperatureModel(repository);

      // Wait for update
      await temperatureModel.update();

      // Expect values to be the same
      expect(temperatureModel.temperatureState, TemperatureState.undeclared);
      expect(temperatureModel.temperatureRecords, mockTemperatureRecords);

      // Change repository values
      temperatureState = TemperatureState.acceptable;
      mockTemperatureRecords = [
        TemperatureRecord(
            time: DateTime.now(), temperature: 34.2, hasSymptoms: false),
      ];

      // Wait for update, then verify values
      await temperatureModel.update();
      expect(temperatureModel.temperatureState, TemperatureState.acceptable);
      expect(temperatureModel.temperatureRecords, mockTemperatureRecords);
    });

    test('declareTemperature adds a TemperatureRecord in repository', () async {
      final repository = MockUserRepository();
      final mockTemperatureRecords = <TemperatureRecord>[];
      var temperatureState = TemperatureState.undeclared;

      // Set up mock interactions
      when(repository.getTemperatureState())
          .thenAnswer((_) async => temperatureState);
      when(repository.declareTemperature(any))
          .thenAnswer((realInvocation) async {
        final declaredTemperature =
            realInvocation.positionalArguments.first as double;
        mockTemperatureRecords.add(TemperatureRecord(
            time: DateTime.now(),
            temperature: declaredTemperature,
            hasSymptoms: false));
        temperatureState = TemperatureState.acceptable;
      });
      when(repository.getTemperatureRecords())
          .thenAnswer((_) async => mockTemperatureRecords);

      // Declare model and wait for it to be updated
      final temperatureModel = TemperatureModel(repository);
      await temperatureModel.update();

      // Expect temperature to be undeclared
      expect(temperatureModel.temperatureState, TemperatureState.undeclared);
      expect(temperatureModel.temperatureRecords, []);

      // Declare temperature now
      const temperatureToDeclare = 34.5;
      temperatureModel.declareTemperature(temperatureToDeclare, false);

      // Wait for model to update
      await temperatureModel.update();

      // Verify that repository method is called
      verify(repository.declareTemperature(temperatureToDeclare));

      expect(temperatureModel.temperatureState, TemperatureState.acceptable);
      expect(temperatureModel.temperatureRecords, mockTemperatureRecords);
      // verifyNoMoreInteractions(repository);
    });
  });
}
