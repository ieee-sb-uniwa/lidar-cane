import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'navigation_service.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:flutter/foundation.dart';
import 'navigation_logic.dart';

class LocationTracker {
  final StreamController<Position> _locationController = StreamController<Position>.broadcast();
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<CompassEvent>? _compassStream;

  Stream<Position> get locationStream => _locationController.stream;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 2, 
  );
  
  final NavigationService navService = NavigationService();

  // We need to store BOTH the latest compass and the latest GPS position
  double _lastCompassReading = 0.0;
  Position? _lastPosition;
  
  // To prevent spamming the servo with 0.1 degree micro-jitters
  double _lastReportedAngle = 0.0;

  Future<void> startTracking(double destLat, double destLng) async {
    await determinePosition(); 
    
    Position startPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    
    debugPrint("Calculating route to destination...");
    await navService.calculateRoute(startPos, destLat, destLng);
    debugPrint("Route calculated successfully!");

    // Set the initial position so the compass has something to work with immediately
    _lastPosition = startPos;

    // COMPASS LISTENER (Fires many times per second)
    _compassStream = FlutterCompass.events?.listen((CompassEvent event) {
      _lastCompassReading = event.heading ?? 0.0;
      _updateServoAngle(); // Run math when user turns their body
    });

    // GPS LISTENER (Fires every 2 meters)
    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _lastPosition = position;
      _updateServoAngle(); // Run math when user walks forward
      _locationController.add(position);
    });
  }

  // THE NEW DECOUPLED MATH FUNCTION
  void _updateServoAngle() {
    if (_lastPosition == null) return;

    double targetBearing = navService.getBearingToNextNode(_lastPosition!);
    double currentHeading = _lastCompassReading; 

    double relativeAngle = (targetBearing - currentHeading + 360) % 360;
    if (relativeAngle > 180) relativeAngle -= 360;

    // SENSOR SMOOTHING: Only print/send if the angle changes by more than 5 degrees.
    // This stops the servo motor from constantly jittering back and forth.
    if ((relativeAngle - _lastReportedAngle).abs() > 5.0) {
      _lastReportedAngle = relativeAngle;
      debugPrint("Servo Angle: ${relativeAngle.toStringAsFixed(1)}°");
      
      // THIS IS WHERE YOU WILL FIRE YOUR BLE COMMAND
      // bleService.write("SERVO:${relativeAngle.toInt()}");
    }
  }

  void stopTracking() {
    _positionStream?.cancel();
    _compassStream?.cancel();
    _positionStream = null;
    _compassStream = null;
  }

  void dispose() {
    _locationController.close();
    _positionStream?.cancel();
    _compassStream?.cancel();
  }

  Future<void> determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions permanently denied.');
    }
  }
}