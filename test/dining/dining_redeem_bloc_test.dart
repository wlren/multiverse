import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:multiverse/model/dining/redeem/dining_redeem_bloc.dart';
import 'package:multiverse/model/dining/redeem/dining_redeem_event.dart';
import 'package:multiverse/model/dining/redeem/dining_redeem_state.dart';
import 'package:multiverse/repository/dining_repository.dart';
import 'package:mockito/mockito.dart';

import '../mocks/menu.dart';
import 'dining_redeem_bloc_test.mocks.dart';

@GenerateMocks([DiningRepository])
void main() {
  group('DiningRedeemBloc', () {
    blocTest<DiningRedeemBloc, DiningRedeemState>(
      'emits [] when nothing is added',
      build: () {
        final mockDiningRepository = MockDiningRepository();
        return DiningRedeemBloc(mockDiningRepository);
      },
      expect: () => [],
    );

    blocTest<DiningRedeemBloc, DiningRedeemState>(
      'emits [PendingRedeemState, SuccessfulRedeemState] when valid meal is redeemed',
      build: () {
        final mockDiningRepository = MockDiningRepository();
        // Success; do not throw exception
        when(mockDiningRepository.redeemMeal(
                sampleMenu.breakfast!.meals.first, 1))
            .thenAnswer((realInvocation) async => {});
        return DiningRedeemBloc(mockDiningRepository);
      },
      act: (bloc) =>
          bloc.add(TryRedeemEvent(sampleMenu.breakfast!.meals.first, 1)),
      expect: () => [
        isA<PendingRedeemState>(),
        isA<SuccessfulRedeemState>(),
      ],
    );

    blocTest<DiningRedeemBloc, DiningRedeemState>(
      'emits [PendingRedeemState, FailedRedeemState] when redeemed meal is not found',
      build: () {
        final mockDiningRepository = MockDiningRepository();
        // Meal not found; throw exception
        when(mockDiningRepository.redeemMeal(
                sampleMenu.breakfast!.meals.first, 1))
            .thenThrow(Exception());
        return DiningRedeemBloc(mockDiningRepository);
      },
      act: (bloc) =>
          bloc.add(TryRedeemEvent(sampleMenu.breakfast!.meals.first, 1)),
      expect: () => [
        isA<PendingRedeemState>(),
        isA<FailedRedeemState>(),
      ],
    );

    blocTest<DiningRedeemBloc, DiningRedeemState>(
      'emits [UnredeemedState] (initial state) when retrying redemption process',
      build: () {
        final mockDiningRepository = MockDiningRepository();
        return DiningRedeemBloc(mockDiningRepository);
      },
      act: (bloc) => bloc.add(RetryRedeemEvent()),
      expect: () => [isA<UnredeemedState>()],
    );
  });
}
