class WeatherTranslations {
  static String translateCondition(String condition) {
    final Map<String, String> translations = {
      'Sunny': 'Izuba',
      'Clear': 'Ikirere cyiza',
      'Partly cloudy': 'Ibicu bike',
      'Cloudy': 'Ibicu',
      'Overcast': 'Ibicu byinshi',
      'Mist': 'Umuhangu',
      'Patchy rain possible': 'Imvura ishobora kugwa',
      'Patchy snow possible': 'Urubura rushobora kugwa',
      'Patchy sleet possible': 'Urubura n\'imvura bishobora kugwa',
      'Patchy freezing drizzle possible': 'Imvura ikonje ishobora kugwa',
      'Thundery outbreaks possible': 'Inkuba ishobora kuririmba',
      'Blowing snow': 'Urubura ruhuha',
      'Blizzard': 'Urubura rukaze',
      'Fog': 'Umuhangu',
      'Freezing fog': 'Umuhangu ukonje',
      'Patchy light drizzle': 'Imvura yoroheje',
      'Light drizzle': 'Imvura yoroheje',
      'Freezing drizzle': 'Imvura ikonje',
      'Heavy freezing drizzle': 'Imvura ikonje ikaze',
      'Patchy light rain': 'Imvura yoroheje',
      'Light rain': 'Imvura yoroheje',
      'Moderate rain at times': 'Imvura yo hagati',
      'Moderate rain': 'Imvura yo hagati',
      'Heavy rain at times': 'Imvura ikaze',
      'Heavy rain': 'Imvura ikaze',
      'Light freezing rain': 'Imvura ikonje yoroheje',
      'Moderate or heavy freezing rain': 'Imvura ikonje ikaze',
      'Light sleet': 'Urubura n\'imvura',
      'Moderate or heavy sleet': 'Urubura n\'imvura bikaze',
      'Patchy light snow': 'Urubura rworoheje',
      'Light snow': 'Urubura rworoheje',
      'Patchy moderate snow': 'Urubura rwo hagati',
      'Moderate snow': 'Urubura rwo hagati',
      'Patchy heavy snow': 'Urubura rukaze',
      'Heavy snow': 'Urubura rukaze',
      'Ice pellets': 'Urubura',
      'Light rain shower': 'Imvura yoroheje',
      'Moderate or heavy rain shower': 'Imvura ikaze',
      'Torrential rain shower': 'Imvura ikaze cyane',
      'Light sleet showers': 'Urubura n\'imvura',
      'Moderate or heavy sleet showers': 'Urubura n\'imvura bikaze',
      'Light snow showers': 'Urubura rworoheje',
      'Moderate or heavy snow showers': 'Urubura rukaze',
      'Light showers of ice pellets': 'Urubura rworoheje',
      'Moderate or heavy showers of ice pellets': 'Urubura rukaze',
      'Patchy light rain with thunder': 'Imvura n\'inkuba',
      'Moderate or heavy rain with thunder': 'Imvura n\'inkuba bikaze',
      'Patchy light snow with thunder': 'Urubura n\'inkuba',
      'Moderate or heavy snow with thunder': 'Urubura n\'inkuba bikaze',
    };

    return translations[condition] ?? condition;
  }

  static String getWindDirection(String dir) {
    final Map<String, String> directions = {
      'N': 'Amajyaruguru',
      'NE': 'Amajyaruguru y\'Uburasirazuba',
      'E': 'Uburasirazuba',
      'SE': 'Amajyepfo y\'Uburasirazuba',
      'S': 'Amajyepfo',
      'SW': 'Amajyepfo y\'Iburengerazuba',
      'W': 'Iburengerazuba',
      'NW': 'Amajyaruguru y\'Iburengerazuba',
    };

    return directions[dir] ?? dir;
  }

  static String getDayName(DateTime date) {
    final Map<int, String> days = {
      1: 'Ku wa mbere',
      2: 'Ku wa kabiri',
      3: 'Ku wa gatatu',
      4: 'Ku wa kane',
      5: 'Ku wa gatanu',
      6: 'Ku wa gatandatu',
      7: 'Ku cyumweru',
    };

    return days[date.weekday] ?? '';
  }

  static String getMonthName(int month) {
    final Map<int, String> months = {
      1: 'Mutarama',
      2: 'Gashyantare',
      3: 'Werurwe',
      4: 'Mata',
      5: 'Gicurasi',
      6: 'Kamena',
      7: 'Nyakanga',
      8: 'Kanama',
      9: 'Nzeli',
      10: 'Ukwakira',
      11: 'Ugushyingo',
      12: 'Ukuboza',
    };

    return months[month] ?? '';
  }
}
