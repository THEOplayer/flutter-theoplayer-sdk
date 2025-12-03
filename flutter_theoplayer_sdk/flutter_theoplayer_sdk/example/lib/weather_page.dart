import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final List<String> _cities = ['Sydney', 'London', 'New York'];
  final Map<String, dynamic> _weatherData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherForCities();
  }

  Future<void> _fetchWeatherForCities() async {
    for (String city in _cities) {
      try {
        final response =
            await http.get(Uri.parse('https://wttr.in/$city?format=j1'));
        if (response.statusCode == 200) {
          _weatherData[city] = json.decode(response.body);
        } else {
          _weatherData[city] = {'error': 'Failed to load weather'};
        }
      } catch (e) {
        _weatherData[city] = {'error': 'Failed to load weather'};
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cities.length,
              itemBuilder: (context, index) {
                String city = _cities[index];
                var weather = _weatherData[city];
                if (weather.containsKey('error')) {
                  return ListTile(
                    title: Text(city),
                    subtitle: Text(weather['error']),
                  );
                }
                return ListTile(
                  title: Text(city),
                  subtitle: Text(
                      '${weather['current_condition'][0]['weatherDesc'][0]['value']}, ${weather['current_condition'][0]['temp_C']}°C'),
                );
              },
            ),
    );
  }
}
