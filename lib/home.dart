import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:untitled11/weather_attributes.dart';
import 'package:untitled11/weather_service.dart';
import 'package:untitled11/weather_forecast_screen.dart';
import 'package:untitled11/weather_condition_box.dart';
import 'package:untitled11/weather_Info_box.dart';
import 'city_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'compass.dart';

class Home extends StatefulWidget {
  String? selectedCity;
  List<String> _selectedCities = [];

  Home(this.selectedCity, this._selectedCities);

  @override
  _WeatherScreenState createState() =>
      _WeatherScreenState(selectedCity, _selectedCities);
}

class _WeatherScreenState extends State<Home> {
  final WeatherService weatherService = WeatherService();
  Weather? weather;
  String? selectedCity;
  List<String> _selectedCities = [];
  List<double>? cityCoords;

  _WeatherScreenState(this.selectedCity, this._selectedCities);


  @override
  void initState() {
    super.initState();
    getWeather();
    _loadSelectedCities();
  }

  Future<void> getWeather() async {
    final weatherService = WeatherService();

    if (selectedCity!.isNotEmpty) {
      await weatherService.getCityCoordinates(selectedCity!);
      cityCoords = weatherService.cityCoordinates[selectedCity!];

      if (cityCoords != null) {
        final data = await weatherService.getWeather(
            lat: cityCoords![0], lon: cityCoords![1]);
        setState(() {
          weather = Weather.fromJson(data);
        });
      }
    }
  }

  Future<void> _loadSelectedCities() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? selectedCities = prefs.getStringList('selected_cities');
    if (selectedCities != null) {
      setState(() {
        _selectedCities = selectedCities;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String path = 'assets/images${weather?.conditionIcon}';

    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    final now = DateTime.now();
    final hour = now.hour;

    String imagePath;

    if (hour >= 6 && hour < 12) {
      imagePath = 'assets/images/morning.jpg';
    } else if (hour >= 12 && hour < 18) {
      imagePath = 'assets/images/day.jpg';
    } else if (hour >= 18 && hour < 22) {
      imagePath = 'assets/images/evening.jpg';
    } else {
      imagePath = 'assets/images/night.jpg';
    }
    return MaterialApp(
      routes: {
        '/forecast': (context) => WeatherForecastScreen(cityCoords),
        '/city': (context) => CityScreen(selectedCity, _selectedCities),
        '/home': (context) => Home(selectedCity, _selectedCities),
      },
      home: Scaffold(
        body: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4942CB),
                Color(0xFF9D97EF),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ClipPath(
                      clipper: WaveClipperTwo(),
                      child: Stack(
                        children: [
                          Image.asset(
                            imagePath,
                            width: width,
                            height: height / 2,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: height * 0.011,
                            left: 0.012,
                            child: Builder(builder: (BuildContext context) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF4942CB),
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(16),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/city");
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 24,
                                ),
                              );
                            }),
                          ),
                        ],
                      )),
                  SizedBox(height: height * 0.01),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Text(
                            DateFormat.yMMMMd('en_US')
                                .add_jm()
                                .format(DateTime.now()),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${weather?.tempC}°C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${weather?.region}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.0224,
                          ),
                          Compass(width: width , height: height , weather: weather)
                        ],
                      ),
                      Column(
                        children: [
                          WeatherInfoBox(width: width, height: height, weather: weather),
                          SizedBox(
                            height: height * 0.0112,
                          ),
                          WeatherConditionBox(width: width, height: height, weather: weather, path: path,)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.015),
                  Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Color(0xFF645DEE),
                          minimumSize: Size(width * 0.728, height * 0.056),
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.0485),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, "/forecast");
                        },
                        child: Text(
                          '7 day forecast',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


