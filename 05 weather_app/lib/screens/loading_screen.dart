import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weatherpt2/screens/location_screen.dart';
import 'package:weatherpt2/services/location.dart';
import 'package:weatherpt2/services/networking.dart';

const apiKey = "03c7a43890b02d4271df485dc1c692f7";

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late double latitude;
  late double longitude;

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    Location location = Location();
    await location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;

    NetworkHelper networkHelper = NetworkHelper('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
    //NEA Weather API: NetworkHelper networkHelper = NetworkHelper('https://api.data.gov.sg/v1/environment/air-temperature');

    var weatherData = await networkHelper.getData();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return LocationScreen(locationWeather: weatherData);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}