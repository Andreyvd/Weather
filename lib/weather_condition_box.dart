import 'package:flutter/material.dart';
import 'package:untitled11/weather_attributes.dart';


class WeatherConditionBox extends StatelessWidget {
  final double width;
  final double height;
  final Weather? weather;
  final String path;

  WeatherConditionBox({
    required this.width,
    required this.height,
    this.weather,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.455,
      height: height * 0.1295,
      decoration: BoxDecoration(
        color: Color(0xFF645DEE),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          SizedBox(height: height * 0.028),
          Text(
            '${weather?.conditionText}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          if (weather?.conditionText != null)
            Image.asset(path.replaceAll('//', '/')),
        ],
      ),
    );
  }
}
