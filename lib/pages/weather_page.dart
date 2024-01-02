import 'package:flutter/material.dart';

import 'package:weather_app/services/weather_service.dart';
import '../models/weather_model.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService(
    "0864c05dcd2a8eab1ad69f8ff213ac3e",
  );
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sunny.json"; // default to sunny

    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/cloudy.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/rainy.json";
      case "thunderstorm":
        return "assets/thunder.json";
      case "clear":
        return "assets/sunny.json";
      default:
        return "assets/sunny.json";
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // city name
          Padding(
            padding: const EdgeInsets.only(bottom: 120.0),
            child: Column(
              children: [
                Text(
                  _weather?.cityName ?? "loading city...",
                  style: GoogleFonts.bebasNeue(
                    fontSize: 30,
                  ),
                  
                ),
                const Icon(Icons.location_on),
              ],
            ),
          ),

          // location icon
          

          // animation
          Center(
            
            child: Lottie.asset(alignment: Alignment.center,
              getWeatherAnimation(
                _weather?.mainCondition,
              ),
            ),
          ),

          // temperature
          Text(
            "${_weather?.temperature.round()}°C",
          ),

          // weather condition
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Text(
              _weather?.mainCondition ?? "",
              style: GoogleFonts.bebasNeue(
                fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
