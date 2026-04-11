import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'navigation_service.dart';

class LocationService {
  //enable controller
  final StreamController<Position> _locationController = StreamController<Position>.broadcast();
  StreamSubscription<Position>? _positionStream;

  // getter for access by other pages 
  Stream<Position> get locationStream => _locationController.stream;
//settings for location accuracy and refresh rate
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  Future<void> startTracking() async {
    //check location settings (see navigation_services for more)
    await determinePosition(); 
//start streaming and find the position
    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _locationController.add(position);
    });
  }
//stop controller
  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }
//close controller
  void dispose() {
    _locationController.close();
    _positionStream?.cancel();
  }
}