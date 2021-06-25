import 'package:bloc/bloc.dart';

import '../../../repository/dining_repository.dart';
import 'dining_redeem_event.dart';
import 'dining_redeem_state.dart';

class DiningRedeemBloc extends Bloc<DiningRedeemEvent, DiningRedeemState> {
  DiningRedeemBloc(this.diningRepository) : super(UnredeemedState());

  final DiningRepository diningRepository;

  @override
  Stream<DiningRedeemState> mapEventToState(DiningRedeemEvent event) async* {
    if (event is TryRedeemEvent) {
      yield PendingRedeemState();
      try {
        await diningRepository.redeemMeal(event.meal, event.mealCount);
        yield SuccessfulRedeemState();
      } on Exception {
        yield FailedRedeemState();
      }
    } else if (event is RetryRedeemEvent) {
      yield UnredeemedState();
    }
  }

}