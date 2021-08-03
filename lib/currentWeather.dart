import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

import 'package:weather_app/models/forcast.dart';
import 'package:weather_app/models/hourly.dart';
import 'package:weather_app/models/location.dart';
import './models/weather.dart';
import 'extensions.dart';

class CurrentWeatherPage extends StatefulWidget {
  final List<Location> locationlist;

  const CurrentWeatherPage(this.locationlist);

  @override
  _CurrentWeatherPageState createState() =>
      _CurrentWeatherPageState(this.locationlist);
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  final List<Location> locationList;
  final Location location;
  Weather _weather;

  _CurrentWeatherPageState(List<Location> locations)
      : this.locationList = locations,
        this.location = locations[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
      ),
      body: ListView(
        children: [
          currentWeatherView(this.locationList, this.location, this.context),
          // forcastViewHouely(this.location),
          // forcastViewDaily(this.location),
        ],
      ),
    );
  }

  Widget weatherBox(Weather _weather) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.all(15.0),
      height: 160.0,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          // image

          Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getWeatherIconBig(_weather.icon),
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: Text(
                        "${_weather.description.capitalizeFirstOfEach}",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: Text(
                        "H:${_weather.high.toInt()} L:${_weather.low.toInt()}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                child: Text(
                  "${_weather.temp.toInt()}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "${_weather.feelsLike.toInt()}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future fetchCurrentWeather(Location location) async {
    Weather weather;
    String city = location.city;
    String apiKey = '4bdfaf20c28bbd2c2b49589bc97225b3';
    final queryParameters = {'q': city, 'appid': apiKey, 'units': 'metric'};
    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);
    // 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      weather = Weather.fromJson(jsonDecode(response.body));
    } else {}

    return weather;
  }

  Future getForecast(Location location) async {
    Forecast forecast;
    String apiKey = '4bdfaf20c28bbd2c2b49589bc97225b3';
    String lat = location.lat;
    String lon = location.lon;
    final queryParameters = {
      'lat': lat,
      'lon': lon,
      'appid': apiKey,
      // 'units': 'metric'
    };
    var url = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);

    var response = await http.get(url);
    if (response.statusCode == 200) {
      forecast = Forecast.fromJson(jsonDecode(response.body));
    }
    return forecast;
  }

  Image getWeatherIconBig(String _icon) {
    String path = 'assets/icons/';
    String imageExtension = '.png';
    return Image.asset(
      path + _icon + imageExtension,
      width: 70,
      height: 70,
    );
  }

  Image getWeatherIconSmall(String _icon) {
    String path = 'assets\icons';
    String imageExtension = '.png';
    return Image.asset(
      path + _icon + imageExtension,
      width: 40,
      height: 40,
    );
  }

  Widget currentWeatherView(
      List<Location> locationList, Location location, BuildContext context) {
    Weather _weather;
    return FutureBuilder(
        future: fetchCurrentWeather(location),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _weather = snapshot.data;
            if (_weather == null) {
              return Text('Geting Error');
            } else {
              return Column(
                children: [
                  // createAppBar(locationList, location, context),
                  weatherBox(_weather),
                  // watherDetailBox(_weather)
                ],
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  // Widget forcastViewHouely(Location location) {
  //   Forecast _forecast;
  //   return FutureBuilder(
  //       future: getForecast(location),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           _forecast = snapshot.data;
  //           if (_forecast == null) {
  //             return Text("Geting error");
  //           } else {
  //             return hourlyBox(_forecast);
  //           }
  //         } else {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //       });
  // }

  // Widget forcastViewDaily(Location location) {
  //   Forecast _forecast;
  //   return FutureBuilder(
  //       future: getForecast(location),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           _forecast = snapshot.data;
  //           if (_forecast == null) {
  //             return Text("Geting error");
  //           } else {
  //             return dalyBox(_forecast);
  //           }
  //         } else {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //       });
  // }
}
