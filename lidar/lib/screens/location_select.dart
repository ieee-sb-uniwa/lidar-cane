import 'package:flutter/material.dart';
import '../services/location_tracker.dart';
import '../services/search_location.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final LocationService _service = LocationService();
  final LocationTracker _tracker = LocationTracker();
  List<SearchResult> _results = [];
  bool _isLoading = false;

  void _onSearch(String value) async {
    setState(() => _isLoading = true);
    final results = await _service.searchPlace(value);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cane Destination Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter destination...",
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _onSearch,
            ),
          ),
          if (_isLoading) LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final place = _results[index];
                return ListTile(
                  title: Text(place.name),
                  subtitle: Text(place.city),
                  onTap: () {
                    // This is where you pass the lat/lng to your 
                    // Routing Service and start the BLE navigation loop
                    print("Heading to: ${place.lat}, ${place.lng}");
                    _tracker.startTracking(place.lat, place.lng);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}