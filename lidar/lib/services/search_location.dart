import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Added for debugPrint

// 1. THIS IS THE MISSING CLASS: It tells Dart how to store the API data
class SearchResult {
  final String name;
  final String city;
  final double lat;
  final double lng;

  SearchResult({
    required this.name, 
    required this.city, 
    required this.lat, 
    required this.lng
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    // Photon returns GeoJSON: [longitude, latitude]
    List coords = json['geometry']['coordinates'];
    var props = json['properties'];
    
    return SearchResult(
      name: props['name'] ?? 'Unknown',
      city: props['city'] ?? props['country'] ?? '',
      lat: coords[1].toDouble(),
      lng: coords[0].toDouble(),
    );
  }
}

// 2. The Service Class that fetches the data
class LocationService {
  Future<List<SearchResult>> searchPlace(String query) async {
    // Prevent sending empty searches to the API
    if (query.trim().isEmpty) {
      debugPrint("Search query was empty!");
      return []; 
    }

    final url = Uri.parse('https://photon.komoot.io/api/?q=${Uri.encodeComponent(query)}&limit=5');

    try {
      final response = await http.get(
        url,
        // Add a custom User-Agent so the free API doesn't block you as a bot
        headers: {
          'User-Agent': 'LidarCaneApp/1.0 (StudentProject)',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List features = data['features'];
        return features.map((f) => SearchResult.fromJson(f)).toList();
      } else {
        // Print the EXACT error from the server so we aren't guessing
        debugPrint('Photon API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load locations: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error searching: $e");
      return [];
    }
  }
}