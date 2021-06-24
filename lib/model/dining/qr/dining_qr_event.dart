import 'dining_qr_data.dart';

abstract class DiningQrEvent {}

class QrRetryEvent extends DiningQrEvent {}

abstract class QrScannedEvent extends DiningQrEvent {}

class InvalidQrScannedEvent extends QrScannedEvent {
  InvalidQrScannedEvent(this.reason);

  String reason;
}
class ValidQrScannedEvent extends QrScannedEvent {
  ValidQrScannedEvent(this.data);

  DiningQrData data;
}