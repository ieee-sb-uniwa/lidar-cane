import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NavigationService {
  final OpenRouteService _ors = OpenRouteService(apiKey: "${dotenv.env['OSM_API_KEY']}");
  List<ORSCoordinate> _routePoints = [];
  int _currentWaypointIndex = 0;

  // 1. Fetch the Pedestrian Route
  Future<void> calculateRoute(Position start, double destLat, double destLng) async {
    final List<ORSCoordinate> route = await _ors.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(latitude: start.latitude, longitude: start.longitude),
      endCoordinate: ORSCoordinate(latitude: destLat, longitude: destLng),
      
    );
    _routePoints = route;
    _currentWaypointIndex = 0;
  }

  // 2. Get the "Next Step" Bearing
  double getBearingToNextNode(Position currentPos) {
    if (_routePoints.isEmpty || _currentWaypointIndex >= _routePoints.length) return 0;

    final target = _routePoints[_currentWaypointIndex];
    
    // Check if we reached the waypoint (within 5 meters)
    double distance = Geolocator.distanceBetween(
      currentPos.latitude, currentPos.longitude, 
      target.latitude, target.longitude
    );

    if (distance < 5 && _currentWaypointIndex < _routePoints.length - 1) {
      _currentWaypointIndex++;
    }

    // Calculate the mathematical bearing (0-360)
    return Geolocator.bearingBetween(
      currentPos.latitude, currentPos.longitude, 
      target.latitude, target.longitude
    );
  }
}