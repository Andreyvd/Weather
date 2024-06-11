import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:untitled11/weather_attributes.dart';



class WeatherService {
  Weather? weather;
  final Map<String, List<double>> cityCoordinates = {};
  final String apiKey = '7ca7532fc7c84f9991f165021240405';
  final String baseUrl = 'http://api.weatherapi.com/v1';

  Future<dynamic> getWeather({required double lat, required double lon}) async {
    final url = '$baseUrl/current.json?key=$apiKey&q=$lat,$lon';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<dynamic> getWeatherForecast({required double lat, required double lon}) async {
    final url = '$baseUrl/forecast.json?key=$apiKey&q=$lat,$lon&days=7';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json;
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }

  Future<void> getCityCoordinates(String city) async {
    final url = 'https://nominatim.openstreetmap.org/search?q=$city&format=json';
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);
    final response = await ioClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json.length > 0) {
        final result = json[0];
        final String lat = result['lat'].toString();
        final String lon = result['lon'].toString();
        cityCoordinates[city] = [double.parse(lat), double.parse(lon)];
      }
    } else {
      throw Exception('Failed to get city coordinates');
    }
  }
}

