import 'package:flutter/material.dart';
import 'package:untitled11/weather_attributes.dart';
import 'package:untitled11/weather_service.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Weather? weather;

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  Future<void> getWeather() async {
    final weatherService = WeatherService();
    final data = await weatherService.getWeather(lat: 33.44, lon: -94.04);
    setState(() {
      weather = Weather.fromJson(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('${weather?.tempC}°C'),
              Text('${weather?.name}°C'),
              Text('${weather?.region}°C'),
              Text('${weather?.humidity}°C'),
              Text('${weather?.pressure}°C'),
              Text('${weather?.windKph}°C'),
              Text('${weather?.conditionText.contains('rain')}'),
              Text('${weather?.conditionText.contains('snow')}'),
            ],
          ),
        ),
      ),
    );
  }
}
