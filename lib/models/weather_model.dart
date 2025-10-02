class WeatherData {
  final Location location;
  final Current current;

  WeatherData({
    required this.location,
    required this.current,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
    );
  }
}

class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      localtime: json['localtime'],
    );
  }
}

class Current {
  final double tempC;
  final double tempF;
  final Condition condition;
  final double windKph;
  final String windDir;
  final double pressureMb;
  final double precipMm;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double visKm;
  final double uv;

  Current({
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.windKph,
    required this.windDir,
    required this.pressureMb,
    required this.precipMm,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.visKm,
    required this.uv,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      tempC: json['temp_c'].toDouble(),
      tempF: json['temp_f'].toDouble(),
      condition: Condition.fromJson(json['condition']),
      windKph: json['wind_kph'].toDouble(),
      windDir: json['wind_dir'],
      pressureMb: json['pressure_mb'].toDouble(),
      precipMm: json['precip_mm'].toDouble(),
      humidity: json['humidity'],
      cloud: json['cloud'],
      feelslikeC: json['feelslike_c'].toDouble(),
      visKm: json['vis_km'].toDouble(),
      uv: json['uv'].toDouble(),
    );
  }
}

class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'],
      icon: json['icon'],
      code: json['code'],
    );
  }
}

class ForecastData {
  final Location location;
  final Current current;
  final Forecast forecast;

  ForecastData({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
      forecast: Forecast.fromJson(json['forecast']),
    );
  }
}

class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      forecastday: (json['forecastday'] as List)
          .map((day) => ForecastDay.fromJson(day))
          .toList(),
    );
  }
}

class ForecastDay {
  final String date;
  final Day day;
  final Astro astro;

  ForecastDay({
    required this.date,
    required this.day,
    required this.astro,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      day: Day.fromJson(json['day']),
      astro: Astro.fromJson(json['astro']),
    );
  }
}

class Day {
  final double maxtempC;
  final double mintempC;
  final double avgtempC;
  final double maxwindKph;
  final double totalprecipMm;
  final double avghumidity;
  final Condition condition;
  final double uv;

  Day({
    required this.maxtempC,
    required this.mintempC,
    required this.avgtempC,
    required this.maxwindKph,
    required this.totalprecipMm,
    required this.avghumidity,
    required this.condition,
    required this.uv,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtempC: json['maxtemp_c'].toDouble(),
      mintempC: json['mintemp_c'].toDouble(),
      avgtempC: json['avgtemp_c'].toDouble(),
      maxwindKph: json['maxwind_kph'].toDouble(),
      totalprecipMm: json['totalprecip_mm'].toDouble(),
      avghumidity: json['avghumidity'].toDouble(),
      condition: Condition.fromJson(json['condition']),
      uv: json['uv'].toDouble(),
    );
  }
}

class Astro {
  final String sunrise;
  final String sunset;

  Astro({
    required this.sunrise,
    required this.sunset,
  });

  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}

class SearchLocation {
  final int id;
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String url;

  SearchLocation({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });

  factory SearchLocation.fromJson(Map<String, dynamic> json) {
    return SearchLocation(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      url: json['url'],
    );
  }
}
