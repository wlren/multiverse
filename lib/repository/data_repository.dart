//Packages
import 'package:amplify_flutter/amplify.dart';

//Local Files
import '../models/model_prodiver.dart';

//General database interactions
class DataRepository {
  Future<NUSStudent?> getUserById(String userId) async {
    try {
      final users = await Amplify.DataStore.query(
        NUSStudent.classType,
        where: NUSStudent.NUSNETID.eq(userId),
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      rethrow;
    }
  }
}
