import 'dart:async';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  Location location = Location();

  final StreamController<LatLng> _locationController =
      StreamController.broadcast();

  LocationService() {
    location.serviceEnabled().then(
      (enabled) {
        if (enabled) {
          location.requestPermission().then(
            (permission) {
              if (permission == PermissionStatus.granted) {
                location.onLocationChanged.listen((locationData) {
                  _locationController.add(
                      LatLng(locationData.latitude!, locationData.longitude!));
                });
              }
            },
          );
        }
      },
    );
  }

  Stream<LatLng> get locationStream => _locationController.stream;
}
