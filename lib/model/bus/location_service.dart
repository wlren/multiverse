import 'dart:async';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  Location location = Location();
  LatLng? currentLocation;

  final StreamController<LatLng> _locationController =
      StreamController.broadcast();

  LocationService() {
    location.serviceEnabled().then(
      (enabled) {
        if (enabled) {
          location.requestPermission().then(
            (permission) {
              if (permission == PermissionStatus.granted) {
                getLocation().then((value) {
                  _locationController.add(value!);
                });

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

  Future<LatLng?> getLocation() async {
    try {
      final userLocation = await location.getLocation();
      currentLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
    } catch (e) {
      throw ('Could not get the location $e');
    }

    return currentLocation;
  }

  Stream<LatLng> get locationStream => _locationController.stream;
}
