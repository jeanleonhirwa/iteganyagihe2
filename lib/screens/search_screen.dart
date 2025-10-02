import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController();
  List<SearchLocation> _searchResults = [];
  bool _isSearching = false;
  String _error = '';

  // Popular locations in Rwanda (Modern district names)
  final List<String> _popularLocations = [
    'Kigali',
    'Musanze',
    'Rubavu',
    'Huye',
    'Rwamagana',
    'Ngoma',
    'Gatsibo',
    'Nyagatare',
    'Rusizi',
    'Karongi',
    'Muhanga',
    'Nyanza',
    'Bugesera',
    'Kayonza',
    'Kirehe',
    'Gicumbi',
    'Rulindo',
    'Gakenke',
    'Nyabihu',
    'Ngororero',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _error = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = '';
    });

    try {
      final results = await _weatherService.searchLocation(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Ntibyashobotse gushaka ahantu';
        _isSearching = false;
        _searchResults = [];
      });
    }
  }

  void _selectLocation(String locationName) {
    Navigator.pop(context, locationName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: _buildSearchContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Shakisha ahantu...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.white70),
                ),
                onChanged: (value) {
                  if (value.length >= 2) {
                    _performSearch(value);
                  } else {
                    setState(() {
                      _searchResults = [];
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              _error,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final location = _searchResults[index];
          return _buildLocationItem(
            location.name,
            '${location.region}, ${location.country}',
          );
        },
      );
    }

    // Show popular locations when no search is active
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ahantu hazwi cyane mu Rwanda',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._popularLocations.map((location) {
            return _buildLocationItem(location, 'Rwanda');
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLocationItem(String name, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.location_on,
          color: Colors.white,
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white70,
          size: 16,
        ),
        onTap: () => _selectLocation(name),
      ),
    );
  }
}
