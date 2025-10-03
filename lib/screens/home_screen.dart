import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../utils/translations.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  ForecastData? _forecastData;
  bool _isLoading = false;
  String _error = '';
  String _currentLocation = 'Kigali';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _loadWeather();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      _animationController.forward(from: 0.0);
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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );

    if (result != null && result is String) {
      setState(() {
        _currentLocation = result;
      });
      _loadWeather();
    }
  }

  Color _getBackgroundColor() {
    if (_forecastData == null) return Colors.blue.shade400;
    
    final hour = DateTime.now().hour;
    final condition = _forecastData!.current.condition.text.toLowerCase();
    
    // Night time (6 PM - 6 AM)
    if (hour >= 18 || hour < 6) {
      return const Color(0xFF1a237e); // Dark blue
    }
    
    // Rainy weather
    if (condition.contains('rain') || condition.contains('drizzle')) {
      return const Color(0xFF455a64); // Grey blue
    }
    
    // Cloudy weather
    if (condition.contains('cloud') || condition.contains('overcast')) {
      return const Color(0xFF546e7a); // Blue grey
    }
    
    // Sunny/Clear weather
    return const Color(0xFF1976d2); // Bright blue
  }

  Color _getSecondaryColor() {
    if (_forecastData == null) return Colors.blue.shade700;
    
    final hour = DateTime.now().hour;
    final condition = _forecastData!.current.condition.text.toLowerCase();
    
    if (hour >= 18 || hour < 6) {
      return const Color(0xFF0d47a1);
    }
    
    if (condition.contains('rain') || condition.contains('drizzle')) {
      return const Color(0xFF263238);
    }
    
    if (condition.contains('cloud') || condition.contains('overcast')) {
      return const Color(0xFF37474f);
    }
    
    return const Color(0xFF0d47a1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getBackgroundColor(),
              _getSecondaryColor(),
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gukurura amakuru...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : _error.isNotEmpty
                  ? _buildErrorState()
                  : _forecastData == null
                      ? const Center(
                          child: Text(
                            'Nta makuru aboneka',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadWeather,
                          color: _getBackgroundColor(),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildHeader(),
                                    const SizedBox(height: 30),
                                    _buildCurrentWeather(),
                                    const SizedBox(height: 30),
                                    _buildWeatherDetails(),
                                    const SizedBox(height: 30),
                                    _buildForecast(),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ikosa ryabaye',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _error,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadWeather,
              icon: const Icon(Icons.refresh),
              label: const Text('Ongera ugerageze'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _getBackgroundColor(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm');
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white70, size: 20),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _forecastData!.location.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${WeatherTranslations.getDayName(now)}, ${timeFormat.format(now)}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 26),
            onPressed: _navigateToSearch,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentWeather() {
    final current = _forecastData!.current;
    final condition = WeatherTranslations.translateCondition(
      current.condition.text,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https:${current.condition.icon}',
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.wb_sunny,
                    size: 100,
                    color: Colors.white,
                  );
                },
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${current.tempC.round()}°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      height: 1,
                    ),
                  ),
                  Text(
                    'C',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            condition,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Hameze nk\'aho ari ${current.feelslikeC.round()}°',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 15,
              ),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  Icons.water_drop_outlined,
                  'Ubushyuhe',
                  '${current.humidity}%',
                  Colors.blue.shade300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDetailCard(
                  Icons.air,
                  'Umuyaga',
                  '${current.windKph.round()} km/h',
                  Colors.cyan.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  Icons.visibility_outlined,
                  'Kureba',
                  '${current.visKm.round()} km',
                  Colors.purple.shade300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDetailCard(
                  Icons.compress,
                  'Umuvuduko',
                  '${current.pressureMb.round()} mb',
                  Colors.orange.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  Icons.cloud_outlined,
                  'Ibicu',
                  '${current.cloud}%',
                  Colors.indigo.shade300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDetailCard(
                  Icons.wb_sunny_outlined,
                  'UV Index',
                  current.uv.toString(),
                  Colors.amber.shade300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String label, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
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
      ),
    );
  }

  Widget _buildForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Iminsi 7 iri imbere',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._forecastData!.forecast.forecastday.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          final date = DateTime.parse(day.date);
          final dayName = index == 0 ? 'Uyu munsi' : WeatherTranslations.getDayName(date);
          final condition = WeatherTranslations.translateCondition(
            day.day.condition.text,
          );

          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
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
                        const SizedBox(height: 2),
                        Text(
                          '${date.day} ${WeatherTranslations.getMonthName(date.month)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
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
                          width: 45,
                          height: 45,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.wb_sunny,
                              size: 45,
                              color: Colors.white,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            condition,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${day.day.mintempC.round()}°',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
