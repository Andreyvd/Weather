class Weather {
  final String name;
  final String region;
  final String conditionText;
  final String conditionIcon;
  final double tempC;
  final int humidity;
  final double pressure;
  final double windKph;
  final String windDir;
  final double feelslikeC;
  final double chanceOfRain;

  Weather({
    required this.name,
    required this.region,
    required this.conditionText,
    required this.conditionIcon,
    required this.tempC,
    required this.humidity,
    required this.pressure,
    required this.windKph,
    required this.windDir,
    required this.feelslikeC,
    required this.chanceOfRain,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final current = json['current'];

    return Weather(
      name: location['name'],
      region: location['region'],
      conditionIcon: current['condition']['icon'],
      conditionText: current['condition']['text'],
      tempC: current['temp_c'],
      humidity: current['humidity'],
      pressure: current['pressure_mb'],
      windKph: current['wind_kph'],
      windDir: current['wind_dir'],
      feelslikeC: current['feelslike_c'],
      chanceOfRain: current['precip_mm'],
    );
  }
}
