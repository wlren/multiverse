import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:multiverse/model/dining/dining_model.dart';
import 'package:multiverse/screens/dining_screen.dart';
import 'package:provider/provider.dart';

import 'dashboard_screen_test.mocks.dart';

@GenerateMocks([DiningModel])
void main() {
  final mockDiningModel = MockDiningModel();

  testWidgets('some test', (tester) async {
    tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => mockDiningModel,
      child: const DiningScreen(),
    ));
    

  });
}