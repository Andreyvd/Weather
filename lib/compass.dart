import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:untitled11/weather_attributes.dart';


class Compass extends StatelessWidget {
  final double width;
  final double height;
  final Weather? weather;

  Compass({required this.width, required this.height, this.weather});

  double convertWindDirToDegrees(String windDir) {
    switch (windDir) {
      case 'N':
        return 0;
      case 'NNE':
        return 22.5;
      case 'NE':
        return 45;
      case 'ENE':
        return 67.5;
      case 'E':
        return 90;
      case 'ESE':
        return 112.5;
      case 'SE':
        return 135;
      case 'SSE':
        return 157.5;
      case 'S':
        return 180;
      case 'SSW':
        return 202.5;
      case 'SW':
        return 225;
      case 'WSW':
        return 247.5;
      case 'W':
        return 270;
      case 'WNW':
        return 292.5;
      case 'NW':
        return 315;
      case 'NNW':
        return 337.5;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.455,
      height: height * 0.270,
      decoration: BoxDecoration(
        color: const Color(0xFF645DEE),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: width * 0.455,
            height: height * 0.200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: width * 0.291,
                      height: height * 0.134,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    Positioned(
                      top: height * 0.011,
                      child: Text(
                        'N',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: height * 0.011,
                      child: Text(
                        'S',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      left: width * 0.024,
                      child: Text(
                        'W',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      right: width * 0.024,
                      child: Text(
                        'E',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Transform.rotate(
                  angle: ((convertWindDirToDegrees('${weather?.windDir}') + 90) * 3.14 / 180),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/images/arrow.png',
                      width: width * 0.194,
                      height: height * 0.0224,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${weather?.windDir}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: height * 0.0112,
          ),
          Text(
            '${weather?.windKph}Kph',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }
}
