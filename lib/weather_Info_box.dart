import 'package:flutter/material.dart';
import 'package:untitled11/weather_attributes.dart';


import 'weather_row.dart';

class WeatherInfoBox extends StatelessWidget {
  final double width;
  final double height;
  final Weather? weather;

  WeatherInfoBox({required this.width, required this.height, this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.455,
      height: height * 0.224,
      decoration: BoxDecoration(
        color: Color(0xFF645DEE),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          SizedBox(height: height * 0.028),
          WeatherRow(
            label: 'humidity',
            value: '${weather?.humidity}%',
          ),
          WeatherRow(
            label: 'feelslikeC',
            value: '${weather?.feelslikeC}°',
          ),
          WeatherRow(
            label: 'pressure',
            value: '${weather?.pressure}mmHg',
          ),
          WeatherRow(
            label: 'chanceOfRain',
            value: '${weather?.chanceOfRain}%',
          ),
        ],
      ),
    );
  }
}
