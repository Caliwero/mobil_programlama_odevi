import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = '59370615918b958cce0c94b5de5253a7';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> getWeather(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric&lang=tr'),
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Hava durumu bilgisi alınamadı');
    }
  }
}