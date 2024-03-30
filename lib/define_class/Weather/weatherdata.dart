import 'dart:convert';

import 'package:http/http.dart' as http;
import 'weather.dart';

class WeatherData {
  final String url =
      "https://api.openweathermap.org/data/2.5/weather?q=Ho%20Chi%20Minh%20City&appid=1bfcdde8752cf01d30d13d3d399a3738&units=metric";
  Future<Weather> getWeatherData() async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return Weather.fromJson(jsonDecode(res.body));
      } else {
        throw Exception("Can not get weather");
      }
    } catch (e) {
      rethrow;
    }
  }
}
