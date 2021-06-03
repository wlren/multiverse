import 'package:multiverse/models/model_prodiver.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class Unauthenticated extends SessionState {}

class Authenticated extends SessionState {
  final NUSStudent user;

  Authenticated({required this.user});
}
