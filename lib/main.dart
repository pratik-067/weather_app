import 'package:flutter/material.dart';
import 'package:weather_app/currentWeather.dart';
import 'package:weather_app/models/location.dart';

void main(List<String> args) {
  runApp(MyApp());
}

//20.792018644320997, 76.69043875509317
class MyApp extends StatelessWidget {
  List<Location> locations = [
    new Location(
        city: 'shegaon',
        country: 'india',
        lat: '76.69043875509317',
        lon: '20.792018644320997')
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: CurrentWeatherPage(locations),
    );
  }
}
