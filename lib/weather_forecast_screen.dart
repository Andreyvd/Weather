import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled11/weather_service.dart';

class WeatherForecastScreen extends StatefulWidget {
  final List<double>? cityCoords;

  WeatherForecastScreen(this.cityCoords);

  @override
  _WeatherForecastScreenState createState() =>
      _WeatherForecastScreenState(cityCoords);
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  final WeatherService weatherService = WeatherService();
  dynamic forecast;
  List<TemperatureData> _chartData = [];
  bool _showList = false;
  final List<double>? cityCoords;

  _WeatherForecastScreenState(this.cityCoords);

  @override
  void initState() {
    super.initState();
    getWeatherForecast();
  }

  Future<void> getWeatherForecast() async {
    try {
      final data = await weatherService.getWeatherForecast(
          lat: cityCoords![0], lon: cityCoords![1]);
      setState(() {
        forecast = data;
        _chartData = _getChartData(data);
      });
    } catch (e) {
      print(e);
    }
  }

  List<TemperatureData> _getChartData(dynamic data) {
    final List<TemperatureData> chartData = [];
    final DateTime today = DateTime.now();
    for (var day in data['forecast']['forecastday']) {
      final DateTime date =
          DateTime.fromMillisecondsSinceEpoch(day['date_epoch'] * 1000);
      if (date.isAfter(today) && chartData.length < 7) {
        chartData.add(TemperatureData(
          date,
          day['day']['mintemp_c'].toDouble(),
          day['day']['maxtemp_c'].toDouble(),
        ));
      }
    }
    return chartData;
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
          'Weather Forecast',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showList = !_showList;
              });
            },
          ),
        ],
      ),
      body: Scrollbar(
        child: forecast == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 2,
                        height: MediaQuery.of(context).size.height,
                        child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat.E(),
                            interval: 21,
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                            majorGridLines: MajorGridLines(width: 0),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          primaryYAxis: NumericAxis(
                            majorGridLines: MajorGridLines(width: 0),
                            labelStyle: TextStyle(
                                color: Colors.white),
                          ),
                          series: <CartesianSeries<TemperatureData, DateTime>>[
                            LineSeries<TemperatureData, DateTime>(
                              dataSource: _chartData,
                              xValueMapper: (TemperatureData data, _) =>
                                  data.time,
                              yValueMapper: (TemperatureData data, _) =>
                                  data.minTemp,
                              name: 'Min Temperature',
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelAlignment: ChartDataLabelAlignment.top,
                                textStyle: TextStyle(color: Colors.white),
                              ),
                              color: Colors.blue,
                            ),
                            LineSeries<TemperatureData, DateTime>(
                              dataSource: _chartData,
                              xValueMapper: (TemperatureData data, _) =>
                                  data.time,
                              yValueMapper: (TemperatureData data, _) =>
                                  data.maxTemp,
                              name: 'Max Temperature',
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelAlignment: ChartDataLabelAlignment.bottom,
                                textStyle: TextStyle(color: Colors.white),
                              ),
                              color: Colors.red,
                            ),
                          ],
                        )),
                  ),
                  if (_showList)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        color: Color(0xFF4942CB),
                        child: ListView.builder(
                          itemCount: forecast['forecast']['forecastday'].length,
                          itemBuilder: (BuildContext context, int index) {
                            final weather =
                                forecast['forecast']['forecastday'][index];
                            final DateTime date =
                                DateTime.fromMillisecondsSinceEpoch(
                                    weather['date_epoch'] * 1000);
                            final String formattedDate =
                                DateFormat('EEEE, MMM d').format(date);
                            final double avgTemp = weather['day']['avgtemp_c'];
                            final String conditionIconUrl =
                                '${weather['day']['condition']['icon']}';
                            final double minTemp = weather['day']['mintemp_c'];
                            final double maxTemp = weather['day']['maxtemp_c'];
                            String path = 'assets/images${conditionIconUrl}';
                            return ListTile(
                              title: Text(formattedDate,
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 4),
                                      Text('Average: $avgTemp°C',
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 4),
                                      Text('Min: $minTemp°C',
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 4),
                                      Text('Max: $maxTemp°C',
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 4),
                                    ],
                                  ),
                                  Column(children: [
                                    Image.asset(path.replaceAll('//', '/'))
                                  ])
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class TemperatureData {
  final DateTime time;
  final double minTemp;
  final double maxTemp;

  TemperatureData(this.time, this.minTemp, this.maxTemp);
}
