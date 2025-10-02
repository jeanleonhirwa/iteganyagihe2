import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../utils/translations.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  ForecastData? _forecastData;
  bool _isLoading = false;
  String _error = '';
  String _currentLocation = 'Kigali';

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final forecast = await _weatherService.getForecast(_currentLocation, 7);
      setState(() {
        _forecastData = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateToSearch() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );

    if (result != null && result is String) {
      setState(() {
        _currentLocation = result;
      });
      _loadWeather();
    }
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
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _error.isNotEmpty
                  ? Center(
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
                            'Ikosa ryabaye',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              _error,
                              style: TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _loadWeather,
                            child: const Text('Ongera ugerageze'),
                          ),
                        ],
                      ),
                    )
                  : _forecastData == null
                      ? const Center(
                          child: Text(
                            'Nta makuru aboneka',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadWeather,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildHeader(),
                                  const SizedBox(height: 24),
                                  _buildCurrentWeather(),
                                  const SizedBox(height: 32),
                                  _buildWeatherDetails(),
                                  const SizedBox(height: 32),
                                  _buildForecast(),
                                ],
                              ),
                            ),
                          ),
                        ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _forecastData!.location.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _forecastData!.location.country,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white, size: 28),
          onPressed: _navigateToSearch,
        ),
      ],
    );
  }

  Widget _buildCurrentWeather() {
    final current = _forecastData!.current;
    final condition = WeatherTranslations.translateCondition(
      current.condition.text,
    );

    return Center(
      child: Column(
        children: [
          Image.network(
            'https:${current.condition.icon}',
            width: 120,
            height: 120,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.wb_sunny,
                size: 120,
                color: Colors.white,
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            '${current.tempC.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            condition,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yumva nk\'aho ari ${current.feelslikeC.round()}°',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    final current = _forecastData!.current;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem(
                Icons.water_drop,
                'Ubushuhe',
                '${current.humidity}%',
              ),
              _buildDetailItem(
                Icons.air,
                'Umuyaga',
                '${current.windKph.round()} km/h',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem(
                Icons.visibility,
                'Kureba',
                '${current.visKm.round()} km',
              ),
              _buildDetailItem(
                Icons.compress,
                'Umuvuduko',
                '${current.pressureMb.round()} mb',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem(
                Icons.cloud,
                'Ibicu',
                '${current.cloud}%',
              ),
              _buildDetailItem(
                Icons.wb_sunny,
                'UV',
                current.uv.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Iminsi 7 iri imbere',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._forecastData!.forecast.forecastday.map((day) {
          final date = DateTime.parse(day.date);
          final dayName = WeatherTranslations.getDayName(date);
          final condition = WeatherTranslations.translateCondition(
            day.day.condition.text,
          );

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${date.day} ${WeatherTranslations.getMonthName(date.month)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Image.network(
                        'https:${day.day.condition.icon}',
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.wb_sunny,
                            size: 40,
                            color: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          condition,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${day.day.maxtempC.round()}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${day.day.mintempC.round()}°',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
