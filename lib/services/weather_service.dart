import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = 'e2a7e5ceecf8419c87c55322250210';
  static const String _baseUrl = 'https://api.weatherapi.com/v1';

  Future<WeatherData> getCurrentWeather(String location) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/current.json?key=$_apiKey&q=$location&aqi=no'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Ntibyashobotse kubona amakuru y\'ikirere');
      }
    } catch (e) {
      throw Exception('Ikosa mu gushaka amakuru: $e');
    }
  }

  Future<ForecastData> getForecast(String location, int days) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/forecast.json?key=$_apiKey&q=$location&days=$days&aqi=no'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ForecastData.fromJson(data);
      } else {
        throw Exception('Ntibyashobotse kubona amakuru y\'ikirere');
      }
    } catch (e) {
      throw Exception('Ikosa mu gushaka amakuru: $e');
    }
  }

  Future<List<SearchLocation>> searchLocation(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search.json?key=$_apiKey&q=$query'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => SearchLocation.fromJson(json)).toList();
      } else {
        throw Exception('Ntibyashobotse gushaka ahantu');
      }
    } catch (e) {
      throw Exception('Ikosa mu gushaka: $e');
    }
  }
}
