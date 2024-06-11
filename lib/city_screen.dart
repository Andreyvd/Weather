import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:untitled11/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class CityScreen extends StatefulWidget {
  String? selectedCity;
  List<String> _selectedCities = [];

  CityScreen(this.selectedCity, this._selectedCities);

  @override
  _CityScreenState createState() =>
      _CityScreenState(selectedCity, _selectedCities);
}

class _CityScreenState extends State<CityScreen> {
  String? selectedCity;
  List<String> _selectedCities = [];

  _CityScreenState(this.selectedCity, this._selectedCities);

  final WeatherService cityCoordinates = WeatherService();

  Future<void> _saveSelectedCities() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selected_cities', _selectedCities);
  }

  void _showCityPicker() async {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4942CB),
          title: Text(
            'Select a city',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            height: height * 0.224,
            child: CSCPicker(
              onCountryChanged: (value) {},
              onStateChanged: (value) {},
              onCityChanged: (value) {
                selectedCity = value;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                if (selectedCity != null) {
                  setState(() {
                    _selectedCities.add(selectedCity!);
                    _saveSelectedCities();
                  });
                }
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _removeCity(String city) {
    setState(() {
      _selectedCities.remove(city);
      cityCoordinates.cityCoordinates.remove(city);
      _saveSelectedCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4942CB),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF4942CB),
        title: Text(
          'Select city',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4942CB),
        shape: CircleBorder(),
        onPressed: _showCityPicker,
        child: Icon(
          Icons.add,
          color: Colors.green,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedCities.length,
                itemBuilder: (BuildContext context, int index) {
                  final city = _selectedCities[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectedCity = city;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Home(selectedCity, _selectedCities)),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFF645DEE),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(
                              city,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _removeCity(city);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
